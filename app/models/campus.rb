class Campus < ActiveRecord::Base
  load_mappings
  include Common::Core::Campus
  #include Common::Core::Ca::Campus

  has_many :assignments
  has_many :persons, :through => :assignments

  def self.regional_national_id
    @@regional_national_id ||= Campus.find_by_campus_shortDesc('Reg/Nat')
  end

  def students(options = {})
    students = []
    self.ministries.each do |m|
      students += m.students
    end
    students.uniq!
  end
end
