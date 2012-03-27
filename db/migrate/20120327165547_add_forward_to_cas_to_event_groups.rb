class AddForwardToCasToEventGroups < ActiveRecord::Migration
  def self.up
    add_column :event_groups, :forward_to_cas, :boolean, :default => false
  end

  def self.down
    remove_column :event_groups, :forward_to_cas
  end
end
