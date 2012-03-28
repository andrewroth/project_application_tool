class EventGroup < Node
  include Common::Pat::EventGroup

  belongs_to :ministry
  belongs_to :location
  belongs_to :key_logo, :class_name => "Attachment", :foreign_key => "key_logo_attachment_id"

  has_many :custom_reports
  has_many :projects
  has_many :forms
  has_many :travel_segments
  has_many :cost_items
  has_many :feedbacks
  has_many :forms
  has_many :reason_for_withdrawals
  has_many :reference_emails
  has_many :tags
  has_many :eventgroup_coordinators, :conditions => { :end_date => nil }
  has_many :prep_items

  has_attachment :content_type => :image, 
                 :storage => :file_system,
                 :path_prefix => 'public/event_groups'

  belongs_to :key_logo, :class_name => "Attachment", :foreign_key => "key_logo_attachment_id"

  attr :filter_hidden, true

  def key_logo_uploaded_data=(f)
    return unless f.is_a?(Tempfile)
    key_logo = Attachment.create(:uploaded_data => f)
    self.key_logo_attachment_id = key_logo.id
  end

  def nested_children
    children.collect(&:self_plus_nested_children).flatten
  end

  def self_plus_nested_children
    [ self ] + nested_children
  end

  def self_plus_nested_form_ids
    self_plus_nested_children.collect(&:form_ids).flatten
  end

  def all_appln_ids
    Appln.find_all_by_form_id(self.self_plus_nested_form_ids, :select => "id").collect(&:id)
  end
  
  def all_project_ids
    self_plus_nested_children.collect(&:project_ids).flatten
  end

  #named_scope :all, lambda { { :conditions => { :a => b } } }

=begin
  def all_profiles(filter_type = [ "Acceptance", "Applying", "StaffProfile", "Withdrawn" ])
    profiles_from_appln = Profile.find_all_by_appln_id(self.all_appln_ids, :conditions => [ "profiles.type IN (?)", filter_type ])
    profiles_from_projects = Profile.find_all_by_project_id(self.self_plus_nested_children.collect(&:project_ids).flatten,
                                                           :conditions => [ "profiles.type IN (?)", filter_type ])
    return (profiles_from_appln + profiles_from_projects).uniq
  end
=end

  def application_form
    forms.find_by_hidden(false) || forms.all.detect{ |f| 
      # find first form that's not the processor form or a reference form
      !f.name != 'Processor Form' && 
        !ReferenceAttribute.find_by_questionnaire_id(f.questionnaire.id)
    }
  end

  def eventgroup_coordinators_names
    eventgroup_coordinators.collect{ |egc| egc.viewer.name if egc.viewer }.compact.join(', ')
  end

  def eventgroup_coordinators_with_inheritance
    r = eventgroup_coordinators
    r += parent.eventgroup_coordinators_with_inheritance if parent
    r
  end

  def has_logo?() !filename.nil? end

  def logo()
    if has_logo? then return public_filename end
    if parent then return parent.logo end
    nil
  end

  def key_logo_url()
    if key_logo then return key_logo.public_filename(:cas_logo) end
    if parent then return parent.key_logo_url end
    nil
  end

  def pat_title
    self[:pat_title] || parent.try(:pat_title)
  end

  def classes(section = nil)
    classes = []

    if section == :a
      classes << 'event_group_hidden' if hidden
    elsif section == :li
      classes << 'event_group_has_logo' if filename
      classes << 'event_group_top_level' if parent.nil?
    end

    classes.join(' ')
  end

  def children_with_hidden_check
    if filter_hidden
      c = children_without_hidden_check.reject{ |c| c.hidden? }
      c.each{ |c| c.filter_hidden = true }
    else
      children_without_hidden_check
    end
  end
  alias_method_chain :children, :hidden_check

  def to_s
    title
  end

  def ensure_emails_exist
    ReferenceEmailsController.types.each_pair do |type_key, type_desc|
      existing = self.reference_emails.find_by_email_type(type_key)
      if (existing == nil)
        # use the default one if possible
        path = File::join(RAILS_ROOT, "app/views/reference_emails/#{type_key}.default.rhtml")
        if File.exists?(path)
          text = File.read(path)
        else
          text = type_desc
        end

        ReferenceEmail.create :email_type => type_key,
          :event_group_id => self.id,
          :text => text
      end
    end
  end

end
