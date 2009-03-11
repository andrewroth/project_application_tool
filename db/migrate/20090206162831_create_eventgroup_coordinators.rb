class CreateEventgroupCoordinators < ActiveRecord::Migration
  def self.up
    create_table :eventgroup_coordinators do |t|
      t.integer :viewer_id
      t.integer :event_group_id

      t.timestamps
    end
  end

  def self.down
    drop_table :eventgroup_coordinators
  end
end
