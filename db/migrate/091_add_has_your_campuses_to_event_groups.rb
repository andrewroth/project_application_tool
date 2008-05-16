class AddHasYourCampusesToEventGroups < ActiveRecord::Migration
  def self.up
    add_column :event_groups, :has_your_campuses, :boolean
  end

  def self.down
    remove_column :event_groups, :has_your_campuses
  end
end
