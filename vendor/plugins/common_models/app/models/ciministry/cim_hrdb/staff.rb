class Staff < CimHrdb
  set_primary_key "staff_id"

  belongs_to :person
end
