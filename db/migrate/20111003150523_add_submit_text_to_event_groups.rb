class AddSubmitTextToEventGroups < ActiveRecord::Migration
  def self.up
    add_column :event_groups, :submit_text, :text
  end

  def self.down
    remove_column :event_groups, :submit_text
  end
end
