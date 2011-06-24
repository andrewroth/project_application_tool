class AddPatTitleToEventGroups < ActiveRecord::Migration
  def self.up
    add_column :event_groups, :pat_title, :string
  end

  def self.down
    remove_column :event_groups
  end
end
