class PersonYear < ActiveRecord::Base
  load_mappings
  set_table_name 'ciministry.cim_hrdb_person_year'
  set_primary_key "personyear_id"

  belongs_to :person
  belongs_to :year_in_school, :foreign_key => 'year_id'
end
