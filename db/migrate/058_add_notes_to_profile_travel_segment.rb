class AddNotesToProfileTravelSegment < ActiveRecord::Migration
  def self.up
    add_column :profile_travel_segments, :notes, :string
  end

  def self.down
    remove_column :profile_travel_segments, :notes
  end
end
