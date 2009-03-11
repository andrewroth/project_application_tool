class CreateEventGroups < ActiveRecord::Migration
  def self.up
    create_table :event_groups do |t|
      t.column :title, :string
      t.column :ministry_id, :integer
      t.column :parent_id, :integer
      t.column :type, :string
      t.column :location_type, :string
      t.column :location_id, :integer
    end
  end

  def self.down
    drop_table :event_groups
  end
end
