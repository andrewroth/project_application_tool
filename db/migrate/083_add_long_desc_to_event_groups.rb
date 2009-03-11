class AddLongDescToEventGroups < ActiveRecord::Migration
  def self.up
    add_column :event_groups, :long_desc, :string
  end

  def self.down
    remove_column :event_groups, :long_desc
  end
end
