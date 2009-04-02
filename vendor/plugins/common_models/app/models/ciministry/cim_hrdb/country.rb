class Country < CimHrdb
  set_primary_key "country_id"
  has_many :provinces
end
