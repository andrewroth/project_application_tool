class CreateProjectsCoordinators < ActiveRecord::Migration
  def self.up
    create_table :projects_coordinators do |t|
      t.integer :viewer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :projects_coordinators
  end
end
