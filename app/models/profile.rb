class Profile < ActiveRecord::Base
  belongs_to :project
  belongs_to :viewer
  belongs_to :appln
  
  has_many :profile_cost_items
  has_many :profile_travel_segments, :order => "position ASC"
  has_many :travel_segments, :through => :profile_travel_segments, :order => "position ASC"
  has_many :optin_cost_items;
  
  #has_many :profile_manual_donations
  #has_many :profile_auto_donations
  #has_many :manual_donations, :through => :profile_manual_donations
  #has_many :auto_donations, :through => :profile_auto_donations

  has_many :auto_donations, :class_name => "AutoDonation", :finder_sql =>
      "SELECT #{AutoDonation.columns.collect{ |ad| "d."+ad.name }.join(', ')} " +
      "FROM profiles p, #{AutoDonation.table_name} d " +
      'WHERE p.id = #{id} and d.participant_motv_code = \'#{motivation_code}\'' + 
      'ORDER BY d.donation_date'
      
  has_many :manual_donations, :class_name => "ManualDonation", :finder_sql =>
      "SELECT #{ManualDonation.columns.collect{ |ad| "d."+ad.name }.join(', ')} " +
      "FROM profiles p, manual_donations d " +
      'WHERE p.id = #{id} and d.motivation_code = \'#{motivation_code}\'' +
      'ORDER BY d.created_at'
  
  # so include will work
  belongs_to :appln

  # --- following methods are to help with cache invalidation 
  def orig_atts
    @orig_atts ||= { }
    @orig_atts['type'] ||= self[:type]
    attributes.merge(@orig_atts)
  end

  def write_attribute(att, val)
    #puts "  write_attribute #{att}=#{val}"
    @orig_atts ||= { }
    @orig_atts[att.to_s] ||= self[att]
    #puts "  #{@orig_atts.inspect}"
    super
  end

  def save!
    success = super
    @orig_atts = nil if success
    success
  end

  def att_changed(att) orig_atts[att.to_s] != self[att] end

  # -- end cache methods
 
  def Profile.types
    [ 'StaffProfile', 'Acceptance', 'Withdrawn', 'Applying' ]
  end
  
  def form_title() appln.form.questionnaire.title if appln && appln.form && appln.form.questionnaire end

  # params:
  #
  #  :type - the new profile type
  #  :status - the new status for the profile
  #  :user - the User object of the person making the change
  #
  def manual_update(params, user = params.delete(:user))
    profile = self
    params[:type] = params[:type].to_s if params[:type]

    # special case for withdrawing so we remember which class it was for the class_when_withdrawn
    #  and state_when_withdrawn
    if params[:type] == 'Withdrawn'
      init_params, profile = manual_update_withdraw_helper
    elsif Profile.types.include? params[:type]
      self[:type] = params[:type]
      self.save!
      profile = Profile.find self.id
    end

    profile.update_attributes params
    profile.save!

    # special case - update the appln's viewer_id if viewer_id changed
    if params[:viewer_id] && profile.appln
      app = profile.appln
      app.viewer_id = profile.viewer_id
      app.save!
    end

    # force classes to do any actions required for chagning state
    if (params[:status] || params[:type]) && profile.respond_to?(:initialize_state)
      profile.initialize_state(
        { :status => (params[:status] || 'unspecified').to_sym, 
          :setter_id => user.id
        }.merge(init_params || {})
      ) 
    end

    true
  end
  
  def withdraw!(options)
    user = options.delete :user
    manual_update options.merge({ 
        :type => 'Withdrawn', 
        :status => (user.viewer.id == viewer_id) ? 'self_withdrawn' : 'declined'
      }), user
  end

  # returns option for the initialize_state method, and the new profile
  #   (ie one with Withdrawn type - with old_class and old_status evenutally
  #   used in class_when_withdrawn & state_when_withdrawn)
  #    
  def manual_update_withdraw_helper
    old_class = self.class.name
    old_status = self.status
    
    self[:type] = 'Withdrawn'
    self.save!
    
    # gotta do a Profile.find call so that the class change takes hold
    profile = Profile.find(self.id)
    options = {
        :old_class => old_class, 
        :old_status => old_status 
    }

    [ options, profile ]
  end
  
  def donations(params = {})
    if params[:cache]
      params[:cache][id.to_s]
    else
      all_donations = manual_donations + auto_donations

      all_donations.sort! { |a,b| 
        if a.donation_date.nil? && b.donation_date.nil?
          0
        elsif a.donation_date.nil? && b.donation_date
          1
        elsif b.donation_date.nil? && a.donation_date
          -1
        else
          a.donation_date <=> b.donation_date
        end
      }

    end || []
  end
  
  def costing(eg)
    calculate_sums(all_cost_items(eg))
  end
  
  # returns an array
  # 
  #    [ <big_total>, [ 
  #         { :name => <type_name>, 
  #           :items => [ <cost_item_1>, ..., <cost_item_n> ]   # where each cost_item is of type given in :name
  #           :totals => <sum of all costs for this type> },
  #         { ...   # repeat for each type
  #           ... }
  #      ]
  #    ]
  #    
  #    (big_total is the sum of all applicable cost types)
  #    
  def calculate_sums(cost_items)
    year = cost_items.collect{|ci| ci.class == YearCostItem ? ci : nil }.compact
    project = cost_items.collect{|ci| ci.class == ProjectCostItem ? ci : nil }.compact
    profile = cost_items.collect{|ci| ci.class == ProfileCostItem ? ci : nil }.compact
    types = [ year, project, profile ]
    types_names = { year.object_id => 'year', project.object_id => 'project', profile.object_id => 'profile' }
    
    # make sure they're only the ones that incur costs (ie not optional, or indicated)
    types.each{ |type| type.delete_if{ |ci| !( !ci.optional || ci.optins.find_by_profile_id(id) ) } }
    
    # sort by list
    types.each{ |list| list.sort!{ |a,b| a.description <=> b.description } }
    
    # calc totals
    totals = Hash[*types.collect { |list| [ list.object_id, list.inject(0.0) { |t,ci| t + ci.amount.to_f } ] }.flatten]
    big_total = totals.values.inject(0.0) { |t,v| t + v }
    
    [ big_total ] + types.collect{|type| { :name => types_names[type.object_id], :items => type, :total => totals[type.object_id] } }
  end
  
  def donations_total(params = {})
    donations(params).inject(0.0) { |received, donation| received + donation.amount.to_f }
  end
  
  def funding_target(eg)
    optin_cost_item_ids = Hash[*optin_cost_items.inject([]) {|a,oci| a + [oci.cost_item_id, true ]}]

    all_cost_items(eg).inject(0.0){ |t,ci| 
      if !ci.optional || optin_cost_item_ids[ci.id]
        t + ci.amount.to_f
      else
        t
      end
    }
  end
  
  def all_cost_items(eg)
    project.all_cost_items(eg) + profile_cost_items
  end
end
