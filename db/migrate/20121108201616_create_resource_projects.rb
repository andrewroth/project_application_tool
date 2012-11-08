class CreateResourceProjects < ActiveRecord::Migration
  def self.up
    create_table :resource_projects do |t|
      t.integer :resource_id
      t.integer :project_id

      t.timestamps
    end
  end

  def self.down
    drop_table :resource_projects
  end
end
