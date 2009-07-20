class DefaultMinistriesAndProjectGroups < ActiveRecord::Migration
  def self.up
    campus_projects = EventGroup.find_or_create_by_title "Projects"
    campus_projects_2008 = EventGroup.find_or_create_by_title_and_parent_id "2008", campus_projects.id
    athletes_in_action_projects = EventGroup.find_or_create_by_title "Athletes in Action Projects"
  end

  def self.down
    campus_projects = EventGroup.find_by_title "Projects"
    campus_projects_2008 = EventGroup.find_by_title_and_parent_id "2008", campus_projects.id
    athletes_in_action_projects = EventGroup.find_by_title "Athletes in Action Projects"

    campus_projects_2008.destroy
    athletes_in_action_projects.destroy
    campus_projects.destroy
  end
end
