class Person < ActiveRecord::Base
  include Common::Core::Person
  include Common::Core::Ca::Person
  include RecordsAttributeUpdatedAt
  load_mappings

  has_many :people
  has_many :attributes_updated_ats

  def viewers
    users
  end

  def viewer
    viewers[0]
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

  def person
    self
  end
end
