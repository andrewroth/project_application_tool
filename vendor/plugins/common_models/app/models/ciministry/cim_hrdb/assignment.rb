class Assignment < CimHrdb
  set_primary_key "assignment_id"
  
  belongs_to :person
  belongs_to :campus
  belongs_to :assignmentstatus

  def status() assignmentstatus.assignmentstatus_desc end
end
