class AddEticketToProfileTravelSegment < ActiveRecord::Migration
  def self.up
    add_column :profile_travel_segments, :eticket, :string
  end

  def self.down
    remove_column :profile_travel_segments, :eticket
  end
end
