class AddCountryIdToProvinceAndPerson < ActiveRecord::Migration
  def self.up
    add_column Province.table_name, :country_id, :integer
    add_column Person.table_name, :country_id, :integer
    add_column Person.table_name, :person_local_country_id, :integer
  end

  def self.down
    remove_column Province.table_name, :country_id
    remove_column Person.table_name, :country_id
  end
end
