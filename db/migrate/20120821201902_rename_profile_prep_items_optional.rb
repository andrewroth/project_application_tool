class RenameProfilePrepItemsOptional < ActiveRecord::Migration
  def self.up
    rename_column :profile_prep_items, :optional, :checked_in
  end

  def self.down
    rename_column :profile_prep_items, :checked_in, :optional
  end
end
