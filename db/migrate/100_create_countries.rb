class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string 'code'
      t.string 'name'
      t.timestamps
    end

    # get a bunch from this file
    file = File.new(File.join(RAILS_ROOT, "db","migrate","country-codes.txt"), "r")
    while (line = file.gets)
      line =~ /(\w+)\W+(.+)/
      puts "code=#{$1} name=#{$2}"
      PatCountry.create :code => $1, :name => $2
    end
    file.close

  end

  def self.down
    drop_table :countries
  end
end
