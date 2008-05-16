class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.column :viewer_id, :integer
      t.column :time_zone, :string
    end
  end

  def self.down
    drop_table :preferences
  end
end
