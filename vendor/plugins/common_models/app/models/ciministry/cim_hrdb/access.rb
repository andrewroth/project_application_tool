class Access < CimHrdb
  set_primary_key "access_id"
  
  belongs_to :person
  belongs_to :viewer
end
