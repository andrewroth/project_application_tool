class PersonYear < CimHrdb
  set_primary_key "personyear_id"
  
  belongs_to :person
  belongs_to :year_in_school, :foreign_key => 'year_id'
end
