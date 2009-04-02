class AddOptionalToProfilePrepItem < ActiveRecord::Migration
  def self.up
    begin
      add_column :profile_prep_items, :optional, :boolean, :default => false
      rescue
    end
  end

  def self.down
    begin
      remove_column :profile_prep_items, :optional
      rescue
    end
  end
end
