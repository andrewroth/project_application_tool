class AddHiddenToEventGroups < ActiveRecord::Migration
  def self.up
    add_column :event_groups, :hidden, :boolean, :default => false
  end

  def self.down
    remove_column :event_groups, :hidden
  end
end
