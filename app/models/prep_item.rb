class PrepItem < ActiveRecord::Base
  validates_presence_of :title, :description
  belongs_to :event_group
  has_and_belongs_to_many :projects
  has_many :profile_prep_items, :include => :profile
  has_many :profiles, :through => :profile_prep_items

  def self.find_prep_items
    find(:all, :order => "title")
  end
 
  def validate
    if applies_to == :event_group then eg = event_group else eg = projects.first.event_group end
    pis = (eg.prep_items + eg.projects.collect {|p| p.prep_items}.flatten).uniq
    pis.delete_if { |pi| pi.title != self.title || pi.id = id}
    errors.add_to_base "Cannont have two paperwork items with the same name within the same event group" if pis.size > 0
  end

  def applies_to
    if event_group_id
      :event_group
    else
      :projects
    end
  end
  
  def applies_to_profile_check_optional(profile)
    return false unless applies_to_profile(profile)

    # check individual flag for optional items only
    if individual
      ppi = profile.profile_prep_item self
      return ppi && ppi.optional
    else
      return true
    end
  end

  def applies_to_profile(profile)
    return false unless profile.class == Acceptance

    (applies_to == :event_group && profile.project.event_group == event_group) || 
      (applies_to == :projects && projects.include?(profile.project))
  end
  
  def ensure_all_profile_prep_items_exist
    ensure_project_ids = if applies_to == :event_group then event_group.projects.collect(&:id) else self.project_ids end
    projects = Project.find ensure_project_ids, :include => { :acceptances => :profile_prep_items }
    
    valid_acceptance_ids_with_ppi = []
    
    for project in projects
      for acceptance in project.acceptances
        #ppi = acceptance.profile_prep_items.find_or_create_by_prep_item_id self.id
        ppi = acceptance.profile_prep_items.detect { |ppi| ppi.prep_item_id == self.id }
        unless ppi
          ppi = acceptance.profile_prep_items.create! :prep_item_id => self.id
        end
        valid_acceptance_ids_with_ppi << acceptance.id
      end
    end
    
    # get rid of profile_prep_items for any profile that's switched projects
    if applies_to == :project
      for ppi in self.profile_prep_items
        unless ppi.profile && valid_acceptance_ids_with_ppi.include?(ppi.profile.id)
          ppi.destroy
        end
      end
    end
    
    return true
  end
end
