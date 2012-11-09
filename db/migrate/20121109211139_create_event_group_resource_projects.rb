class CreateEventGroupResourceProjects < ActiveRecord::Migration
  def self.up
    create_table :event_group_resource_projects do |t|
      t.integer :event_group_resource_id
      t.integer :project_id

      t.timestamps
    end
  end

  def self.down
    drop_table :event_group_resource_projects
  end
end
