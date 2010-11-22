class Person < ActiveRecord::Base
  load_mappings
  include Common::Core::Person

  def viewer
    user
  end

  #belongs_to :viewer, :foreign_key => :user_id

  def campus_abbrev(o = {})
    self.campus(o) ? self.campus(o).abbrv : ''
  end
  
  def campus_name(o = {})
    self.campus(o) ? self.campus(o).name : ''
  end

  def name
    self.full_name
  end
end
