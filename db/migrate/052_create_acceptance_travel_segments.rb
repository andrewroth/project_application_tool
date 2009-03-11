class CreateAcceptanceTravelSegments < ActiveRecord::Migration
  def self.up
    create_table :acceptance_travel_segments do |t|
      t.column :acceptance_id, :integer
      t.column :travel_segment_id, :integer
      t.column :position, :integer
    end
  end

  def self.down
    drop_table :acceptance_travel_segments
  end
end
