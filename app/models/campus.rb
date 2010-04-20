class Campus < ActiveRecord::Base
  load_mappings

  has_many :assignments
  has_many :persons, :through => :assignments

  def self.regional_national_id
    @@regional_national_id ||= Campus.find_by_campus_shortDesc('Reg/Nat')
  end

  def students(options = {})
    # Following line breaks with a rails bug on eager loading
    #assignments.find_all_by_assignmentstatus_id(Assignmentstatus.campus_student_ids, 
    #    :include => { :person => :viewers }, :select => options[:select] ).collect { |a|
    #  a.person
    #}
    assignments.find_all_by_assignmentstatus_id(Assignmentstatus.campus_student_ids,
        :select => options[:select]
    ).collect { |a| a.person }

    #assignments.find(:all,
    #    :include => { :person => :viewers }, :select => options[:select] ).collect { |a|
    #  a.person
    #}
  end
end
