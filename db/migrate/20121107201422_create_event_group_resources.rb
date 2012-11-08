class CreateEventGroupResources < ActiveRecord::Migration
  def self.up
    create_table :event_group_resources do |t|
      t.integer :event_group_id
      t.integer :resource_id
      t.string :description
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :event_group_resources
  end
end
