class CreateTravelSegments < ActiveRecord::Migration
  def self.up
    create_table :travel_segments do |t|
       t.column :id, :integer
       t.column :year, :integer
       t.column :departure_city, :string
       t.column :departure_time, :datetime
       t.column :carrier, :string
       t.column :arrival_city, :string
       t.column :arrival_time, :datetime
       t.column :flight_no, :string
       t.column :notes, :text
    end
  end

  def self.down
    drop_table :travel_segments
  end
end
