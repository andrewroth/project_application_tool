class AddDefaultTextAreaLengthToEventGroups < ActiveRecord::Migration
  def self.up
    add_column :event_groups, :default_text_area_length, :integer, :default => 4000
  end

  def self.down
    remove_column :event_groups, :default_text_area_length
  end
end
