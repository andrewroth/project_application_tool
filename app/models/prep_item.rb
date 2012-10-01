class PrepItem < ActiveRecord::Base
  validates_presence_of :title, :description
  belongs_to :event_group
  has_and_belongs_to_many :projects
  has_many :profile_prep_items, :include => :profile
  has_many :profiles, :through => :profile_prep_items

  alias_method :original_projects, :projects
  def projects
    event_group.try(:projects) || self.original_projects
  end

  # Returns all profiles that this item might apply to.
  # If this prep item is assigned to individual profiles, it still includes all profiles that may or may
  # not have been assigned.
  def all_profiles(project_filter = nil)
    return @all_profiles if @all_profiles

    @all_profiles = (projects.collect(&:acceptances) + projects.collect(&:staff_profiles)).flatten.uniq
    @all_profiles.delete_if{ |p| p.project != project_filter } if project_filter
    return @all_profiles
  end

  # Returns all profiles that this item does apply to.
  # If this prep item is assigned to individual profiles, it only includes profiles that have been assigned.
  def profiles(project_filter = nil)
    if !self.individual
      return all_profiles(project_filter)
    else
      return all_profiles(project_filter).find_all{ |p| profile_prep_items.find_by_prep_item_id(self.id).try(:checked_in) }
    end
  end

  def applies_to_profile(profile)
    all_profiles.include?(profile)
  end

  def applies_to_profile_check_checked_in(profile)
    debugger if self.title == "Security Agreement"
    profiles.include?(profile)
  end
end
