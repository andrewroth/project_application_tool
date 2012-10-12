class AddItineraryAvailableToProjects < ActiveRecord::Migration
  def self.up
    #add_column :projects, :itinerary_available, :date
  end

  def self.down
    remove_column :projects, :itinerary_available
  end
end
