class Person < ActiveRecord::Base
  include Common::Core::Person
  include Common::Core::Ca::Person
  load_mappings

  def viewer
    viewers[0]
  end

  def campus_abbrev(o = {})
    self.campus(o) ? self.campus(o).abbrv : ''
  end
  
  def campus_name(o = {})
    self.campus(o) ? self.campus(o).name : ''
  end
end
