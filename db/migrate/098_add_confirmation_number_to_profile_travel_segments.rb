class AddConfirmationNumberToProfileTravelSegments < ActiveRecord::Migration
  def self.up
    add_column :profile_travel_segments, :confirmation_number, :string
  end

  def self.down
    remove_column :profile_travel_segments, :confirmation_number
  end
end
