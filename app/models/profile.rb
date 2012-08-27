class Profile < ActiveRecord::Base
  include Common::Pat::Profile
  include ActionView::Helpers::NumberHelper
  belongs_to :viewer
  belongs_to :appln
  belongs_to :reuse_appln, :class_name => "Appln"
  
  has_many :profile_cost_items
  has_many :profile_travel_segments, :order => "position ASC"
  has_many :travel_segments, :through => :profile_travel_segments, :order => "position ASC"
  has_many :optin_cost_items;
  has_many :profile_prep_items
  has_many :profile_notes
  
  #has_many :profile_manual_donations
  #has_many :profile_auto_donations
  #has_many :manual_donations, :through => :profile_manual_donations
  #has_many :auto_donations, :through => :profile_auto_donations

  # so include will work
  belongs_to :appln

  named_scope :by_event_group, lambda { |*p|
    if p.first.to_s == 'all'
      all_appln_ids = EventGroup.roots.collect(&:all_appln_ids).flatten
      all_project_ids = EventGroup.roots.collect(&:all_project_ids).flatten
    else
      eg = EventGroup.find p.first
      all_appln_ids = eg.all_appln_ids
      all_project_ids = eg.all_project_ids
    end
    conditions_text = "(appln_id IN (?) OR project_id IN (?))"
    conditions_text += " AND #{p.second}" if p.second.present?
    conditions_subs = [ all_appln_ids, all_project_ids ]
    conditions_subs += p.third if p.third.present?
    { :conditions => ([ conditions_text ] + conditions_subs) }
  }

  def support_claimed_currency
    if support_claimed.present?
      number_to_currency(support_claimed, :unit => "", :delimiter => "")
    else
      "click to update"
    end
  end

  def support_claimed_currency=(val)
    self.support_claimed = val
  end

  def support_claimed_percent
    ((support_claimed.to_f / cached_costing_total.to_f) * 100).to_i
  end

  def form_title() appln.form.questionnaire.title if appln && appln.form && appln.form.questionnaire end

  # params:
  #
  #  :type - the new profile type
  #  :status - the new status for the profile
  #  :viewer - the Viewer of the person making the change
  #
  def manual_update(params, viewer = params.delete(:viewer))
    profile = self
    params[:type] = params[:type].to_s if params[:type]

    # special case for withdrawing so we remember which class it was for the class_when_withdrawn
    #  and state_when_withdrawn
    profile.orig_atts['type'] = self[:type]
    if params[:type] == 'Withdrawn'
      init_params, profile = manual_update_withdraw_helper
    elsif Profile.types.include? params[:type]
      self[:type] = params[:type]
      self.save!
      profile = Profile.find self.id
    end

    # take out any direct viewer or user refs since setting them can cause errors
    # if the wrong one is passed in.  going by id is much safer
    params[:viewer_id] = params.delete(:user).id if params[:user]
    params[:viewer_id] = params.delete(:viewer).id if params[:viewer]
    
    # update!
    profile.update_attributes params

    # special case - update the appln's viewer_id if viewer_id changed
    if params[:viewer_id] && profile.appln && profile.appln.viewer_id != params[:viewer_id]
      app = profile.appln
      app.viewer_id = profile.viewer_id
      app.save!
    end

    # force classes to do any actions required for chagning state
    if (params[:status] || params[:type]) && profile.respond_to?(:initialize_state)
      profile.initialize_state(
        { :status => (params[:status] || 'unspecified').to_sym, 
          :setter_id => viewer.id
        }.merge(init_params || {})
      ) 
    end

    true
  end
  
  def withdraw!(options)
    viewer = options.delete :viewer
    manual_update options.merge({ 
        :type => 'Withdrawn', 
        :status => (viewer.id == viewer_id) ? 'self_withdrawn' : 'declined'
      }), viewer
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
  
  def funding_target(eg, use_project_from_eg = false)
    optin_cost_item_ids = Hash[*optin_cost_items.inject([]) {|a,oci| a + [oci.cost_item_id, true ]}]

    all_cost_items(eg, use_project_from_eg).inject(0.0){ |t,ci| 
      if !ci.optional || optin_cost_item_ids[ci.id]
        t + ci.amount.to_f
      else
        t
      end
    }
  end
  
  def all_cost_items(eg, use_project_from_eg = false, paying_only = false)
    project_to_use = if use_project_from_eg
        eg.projects.detect{ |p| p.id == project.id if project }
      else
        project
      end
    return [ ] unless project_to_use

    cis = project_to_use.all_cost_items(eg) + profile_cost_items

    if paying_only
      optin_cost_item_ids = Hash[*optin_cost_items.inject([]) {|a,oci| a + [oci.cost_item_id, true ]}]
      cis.find_all{ |ci| !ci.optional || optin_cost_item_ids[ci.id] }
    else
      return cis
    end
  end
  
  # all prep items that apply to this profile
  def all_prep_items
    project.prep_items + project.event_group.prep_items
  end
  
  def all_profile_prep_items
    ppis = self.profile_prep_items(:include => :prep_item)
    for ppi in ppis
      if ppi.prep_item.nil?
        ppi.destroy
        reload_ppis = true
      end
    end
    ppis = self.profile_prep_items(:include => :prep_item) if reload_ppis
    ppis
  end

  def profile_prep_item(pi)
    profile_prep_items.detect{ |ppi| ppi.prep_item_id == pi.id }
  end

  after_create do |profile|
    profile.update_costing_total_cache
  end

  def after_save
    if @update_costing_total_cache
      @update_costing_total_cache = false
      if project
        project.reload
        update_costing_total_cache
      end
    end
  end

  def update_costing_total_cache(eg = nil, use_project_from_eg = false)
    eg ||= (project.event_group if project) || (appln.form.event_group if appln && appln.form)
    self[:cached_costing_total] = if eg then funding_target(eg, use_project_from_eg) else nil end
    save!
  end

  def event_group() project.try(:event_group) || self.try(:appln).try(:form).try(:event_group) end
end
