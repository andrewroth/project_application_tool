class Person < ActiveRecord::Base
  load_mappings
  include Common::Core::Person
  #include Pat::Ca::Person # enable this in cdn branch

  #def province_id=(val) permanent_address.state = val end
  def person_localprovince_id=(val) current_address.state = val end
  def person_permanentprovince_id=(val) permanent_address.state = val end
  def person_emergencyprovince_id=(val) emergency_address.state = val end

  def viewer
    viewers[0]
  end

  def campus_abbrev(o = {})
    self.campus(o) ? self.campus(o).campus_abbrev : ''
  end
  
  def campus_name(o = {})
    self.campus(o) ? self.campus(o).campus_name : ''
  end
end
