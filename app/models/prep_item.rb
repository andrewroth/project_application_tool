class PrepItem < ActiveRecord::Base
  validates_presence_of :title, :description
  belongs_to :event_group
  has_and_belongs_to_many :projects
  has_many :profile_prep_items, :include => :profile
  has_many :profiles, :through => :profile_prep_items
  after_save :clear_unapplicable_profile_prep_items

  alias_method :original_projects, :projects
  def projects
    event_group.try(:projects) || self.original_projects
  end

  # Returns all profiles that this item might apply to.
  # If this prep item is assigned to individual profiles, it still includes all profiles that may or may
  # not have been assigned.
  def potential_profiles(project_filter = nil)
    @potential_profiles ||= {}
    return @potential_profiles[project_filter] if @potential_profiles[project_filter]

    @potential_profiles[project_filter] = (projects.collect(&:acceptances) + projects.collect(&:staff_profiles)).flatten.uniq
    @potential_profiles[project_filter].delete_if{ |p| p.project != project_filter } if project_filter
    return @potential_profiles[project_filter]
  end

  # Returns all profiles that this item does apply to.
  # If this prep item is assigned to individual profiles, it only includes profiles that have been assigned.
  def applicable_profiles(project_filter = nil)
    if !self.individual
      return potential_profiles(project_filter)
    else
      return potential_profiles(project_filter).find_all{ |p| profile_prep_items.find_by_prep_item_id(self.id).try(:checked_in) }
    end
  end

  def can_be_assigned(profile)
    potential_profiles.include?(profile)
  end

  def is_assigned(profile)
    applicable_profiles.include?(profile)
  end

  def clear_unapplicable_profile_prep_items
    profile_prep_items.find_all{ |profile_prep_item| !can_be_assigned(profile_prep_items.profile) }.collect(&:destroy)
  end
end
