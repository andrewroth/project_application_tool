class RemoveMinistryIdFromEventGroups < ActiveRecord::Migration
  def self.up
    remove_column :event_groups, :ministry_id
  end

  def self.down
    add_column :event_groups, :ministry_id, :integer_id
  end
end
