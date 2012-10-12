class MoveReceivedToReceivedAtForProfilePrepItems < ActiveRecord::Migration
  def self.up
    add_column :profile_prep_items, :received_at, :datetime
    ProfilePrepItem.reset_column_information
    ProfilePrepItem.update_all("received_at = NOW()", "received = 1")
    remove_column :profile_prep_items, :received
  end

  def self.down
  end
end
