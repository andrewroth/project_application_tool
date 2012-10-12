class PrepItem < ActiveRecord::Base
  validates_presence_of :title, :description
  belongs_to :event_group
  has_and_belongs_to_many :projects
  has_many :profile_prep_items, :include => :profile
  has_many :profiles, :through => :profile_prep_items
  belongs_to :prep_item_category
  after_save :clear_unapplicable_profile_prep_items

  def priority
    return 3 unless deadline.to_time
    if deadline.to_time > 2.month.from_now
      return 3
    elsif deadline.to_time > 1.months.from_now
      return 2
    else
      return 1
    end
  end

  def <=>(other)
    self.title <=> other.title
  end

  def projects_csv
    projects.collect(&:title).join(", ")
  end

  def projects_csv=(val)
    project_titles = val.split(',')
    project_ids = []
    self.projects = []
    project_titles.each do |title|
      project = self.event_group.projects.find_or_create_by_title(title)
      self.projects << project
    end
  end

  def as_json(params)
    super(params.merge(:methods => [ :projects_csv, :category, :project_ids ]))
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
    profile_prep_items.find_all{ |profile_prep_item| !can_be_assigned(profile_prep_item.profile) }.collect(&:destroy)
  end
end
