class DefaultMinistriesAndProjectGroups < ActiveRecord::Migration
  def self.up
    ccc = Ministry.find_or_create_by_name "Campus Crusade for Christ"
    canada = Ministry.find_or_create_by_name_and_parent_id "Canada", ccc.id
    campus = Ministry.find_or_create_by_name_and_parent_id "Campus", canada.id
    aia = Ministry.find_or_create_by_name_and_parent_id "Athletes in Action", ccc.id

    campus_projects = EventGroup.find_or_create_by_title_and_ministry_id "Projects", campus.id
    campus_projects_2007 = EventGroup.find_or_create_by_title_and_parent_id "2007", campus_projects.id
    campus_projects_2008 = EventGroup.find_or_create_by_title_and_parent_id "2008", campus_projects.id
    athletes_in_action_projects = EventGroup.find_or_create_by_title "Athletes in Action Projects"

    # make each existing model that has an event_group_id ref to be for 2007 projects
    AddEventGroupId.add_models.each do |m|
      model = m.to_s.singularize.camelcase.constantize
      model.find(:all).each do |row|
        row.event_group_id = campus_projects_2007.id
        row.save!
      end
    end
  end

  def self.down
    Ministry.delete_all true
    EventGroup.delete_all true
  end
end
