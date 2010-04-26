class Person < ActiveRecord::Base
  include Common::Core::Person
  include Common::Core::Ca::Person
  load_mappings

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
