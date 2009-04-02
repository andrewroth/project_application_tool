class Province < CimHrdb
  set_primary_key "province_id"

  belongs_to :country
end
