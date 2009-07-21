class AddCountryIdToProvinceAndPerson < ActiveRecord::Migration
  def self.up
    add_column Province.table_name, :country_id, :integer unless Province.column_names.include?('country_id')
    add_column Person.table_name, :country_id, :integer unless Person.column_names.include?('country_id')
    add_column Person.table_name, :person_local_country_id, :integer unless Person.column_names.include?('person_local_country_id')
  end

  def self.down
    remove_column Province.table_name, :country_id
    remove_column Person.table_name, :country_id
  end
end
