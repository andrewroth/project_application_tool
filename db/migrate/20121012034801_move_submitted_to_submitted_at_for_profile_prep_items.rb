class MoveSubmittedToSubmittedAtForProfilePrepItems < ActiveRecord::Migration
  def self.up
    add_column :profile_prep_items, :completed_at, :datetime
    ProfilePrepItem.reset_column_information
    ProfilePrepItem.update_all("completed_at = NOW()", "submitted = 1")
    remove_column :profile_prep_items, :submitted
  end

  def self.down
  end
end
