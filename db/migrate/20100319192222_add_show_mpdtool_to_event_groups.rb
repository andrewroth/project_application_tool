class AddShowMpdtoolToEventGroups < ActiveRecord::Migration
  def self.up
    add_column :event_groups, :show_mpdtool, :boolean, :default => false
  end

  def self.down
    remove_column :event_groups, :show_mpdtool
  end
end
