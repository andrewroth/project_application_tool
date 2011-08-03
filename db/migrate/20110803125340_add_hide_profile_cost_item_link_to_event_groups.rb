class AddHideProfileCostItemLinkToEventGroups < ActiveRecord::Migration
  def self.up
    add_column :event_groups, :hide_profile_cost_item_link, :boolean, :default => false
  end

  def self.down
    remove_column :event_groups, :hide_profile_cost_item_link
  end
end
