class AddHealthCoverageCountryToEmerg < ActiveRecord::Migration
  def self.up
    add_column Emerg.table_name, :health_coverage_country, :string
  end

  def self.down
    remove_column Emerg.table_name, :health_coverage_country, :string
  end
end
