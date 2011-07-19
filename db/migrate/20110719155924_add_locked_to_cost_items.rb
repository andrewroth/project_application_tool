class AddLockedToCostItems < ActiveRecord::Migration
  def self.up
    add_column :cost_items, :locked, :boolean, :default => false
  end

  def self.down
    remove_column :cost_items, :locked
  end
end
