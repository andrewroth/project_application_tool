class AddSupportAddressToEventGroups < ActiveRecord::Migration
  def self.up
    add_column :event_groups, :support_address, :text
  end

  def self.down
    remove_column :event_groups, :support_address
  end
end
