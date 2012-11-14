class AddSeenHelpToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :seen_help, :boolean, :default => false
  end

  def self.down
    remove_column :profiles, :seen_help
  end
end
