class Person < ActiveRecord::Base
  load_mappings
  include Common::Core::Person

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
