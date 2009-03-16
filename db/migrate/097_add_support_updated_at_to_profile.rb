class AddSupportUpdatedAtToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :support_claimed_updated_at, :datetime
  end

  def self.down
    remove_column :profiles, :support_claimed_updated_at
  end
end
