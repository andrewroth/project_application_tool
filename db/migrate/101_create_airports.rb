class CreateAirports < ActiveRecord::Migration
  def self.up
    create_table :airports do |t|
      t.string 'code'
      t.string 'name'
      t.string 'city'
      t.string 'country_code'
      t.string 'area_code'

      t.timestamps
    end
  end

  def self.down
    drop_table :airports
  end
end
