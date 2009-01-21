class Person < ActiveRecord::Base
  load_mappings
  doesnt_implement_attributes :major => '', :minor => '', :url => '', :staff_notes => ''

  has_many :person_years, :foreign_key => _(:id, :year_in_school)
  has_many :year_in_schools, :through => :person_years

  has_one :access
  has_many :users, :through => :access

  has_many :assignments, :include => :assignmentstatus
  has_many :assignmentstatuses, :through => :assignments

  has_one :emerg
  belongs_to :gender_, :class_name => "Gender", :foreign_key => :gender_id

  def user
    users.first
  end

  def user=(val)
    throw "not implemented"
  end

  def year_in_school
    if year_in_schools.empty? then '' else year_in_schools.first.year_id end
  end

  def year_in_school=(val)
    throw "not implemented"
  end

  def birth_date() emerg.emerg_birthdate end

  def gender() gender_ ? gender_.desc : '???' end

  PRIMARY_ASSIGNMENTS_ORDER = ["Current Student", "Alumni", "Staff", "Attended", "Staff Alumni", "Unknown Status"]

  def primary_campus
    as = assignments.sort { |a1, a2| 
          p1 = PRIMARY_ASSIGNMENTS_ORDER.index a1.assignmentstatus.assignmentstatus_desc
          p2 = PRIMARY_ASSIGNMENTS_ORDER.index a2.assignmentstatus.assignmentstatus_desc
          p1 <=> p2
    }
    as.first.campus
  end

  def current_address() CurrentAddress.find(id) end
  def permanent_address() PermanentAddress.find(id) end

  def graduation_date() person_years.length > 1 ? person_years.first.grad_date : nil end
end
