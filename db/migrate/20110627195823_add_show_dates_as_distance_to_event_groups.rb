class AddShowDatesAsDistanceToEventGroups < ActiveRecord::Migration
  def self.up
    add_column :event_groups, :show_dates_as_distance, :boolean, :default => false
  end

  def self.down
    remove_column :event_groups, :show_dates_as_distance
  end
end
