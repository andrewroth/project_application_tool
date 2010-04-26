class AddHealthCoverageCountryToEmerg < ActiveRecord::Migration
  def self.up
    add_column :emergs, :health_coverage_country, :string
  end

  def self.down
    remove_column :emergs, :health_coverage_country
  end
end
