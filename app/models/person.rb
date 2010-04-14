class Person < ActiveRecord::Base
  load_mappings
  include Common::Core::Person
  include Common::Core::Ca::Person

  # this overrides the has_many :campsues :through => :campus_involvements
  has_many :campuses, :through => :assignments, :source => :campus

  belongs_to :loc_province, :foreign_key => "person_local_province_id", :class_name => "Province"
  belongs_to :loc_country, :foreign_key => "person_local_country_id", :class_name => "Country"
  belongs_to :perm_province, :foreign_key => "province_id", :class_name => "Province"
  belongs_to :perm_country, :foreign_key => "country_id", :class_name => "Country"
  belongs_to :title2, :foreign_key => "title_id", :class_name => "Title"
  
  has_many :viewers, :through => :access

  def self.search_by_name(name)
    name.strip!
    fname = name.sub(/ +.+/i, '')
    lname = name.sub(/.+ +/i, '') if name.include? " "
    people = if !lname.nil?
      Person.find(:all,
                  :conditions => ["person_fname like ? AND person_lname like ?", "%#{fname}%", "%#{lname}%"],
                  :order => "person_fname, person_lname")
    else
      Person.find(:all,
                  :conditions => ["person_fname like ? OR person_lname like ?", "%#{fname}%", "%#{fname}%"],
                  :order => "person_fname, person_lname")
    end

    people
  end

  def title=(v) title2 = v end
  def title() if title2 then title2.desc else '' end end

  # alias to use CDM version
  def grad_date() graduation_date end
  def emerg() get_emerg end

  def viewer
    viewers[0]
  end
  
  @@current_student_assignment_status_id = @@unknown_assignment_status_id = nil

  def campus(options = {})

    # look for current assignment first
    if @@current_student_assignment_status_id.nil?
      @@current_student_assignment_status_id = Assignmentstatus.find_by_assignmentstatus_desc("Current Student").id
    end

    if @@current_student_assignment_status_id 
      if options[:search_arrays]
        c = assignments.detect{ |a| a.assignmentstatus_id == @@current_student_assignment_status_id }
      else
        c = assignments.find_by_assignmentstatus_id @@current_student_assignment_status_id, :include => :campus
      end

      return c.campus if c
    end

    # look for unknown assignment
    if @@unknown_assignment_status_id.nil?
      @@unknown_assignment_status_id = Assignmentstatus.find_by_assignmentstatus_desc("Unknown Status").id
    end

    if @@unknown_assignment_status_id 
      if options[:search_arrays]
        u = assignments.detect{ |u| u.assignmentstatus_id == @@unknown_assignment_status_id }
      else
        u = assignments.find_by_assignmentstatus_id @@unknown_assignment_status_id, :include => :campus 
      end

      return u.campus if u
    end

    return nil
  end

  def name
    "#{person_fname.capitalize} #{person_lname.capitalize}"
  end
  
  def first_name
    self.person_fname
  end
  
  def last_name
    self.person_lname
  end
  
  def campus_shortDesc(o = {})
    self.campus(o) ? self.campus(o).campus_shortDesc : ''
  end
  
  def campus_longDesc(o = {})
    self.campus(o) ? self.campus(o).campus_desc : ''
  end
  
  def email
    self.person_email
  end
  
  def gender
    if self.gender_id == 1 then 'M' elsif self.gender_id == 2 then 'F' else '?' end
  end
  
  def legal_first_name
    self.person_legal_fname
  end
  
  def legal_last_name
    self.person_legal_lname
  end
  
  def permanent_phone
    self.person_phone
  end
  
  def permanent_address
    self.person_addr
  end
  
  def permanent_city
    self.person_city
  end
  
  def permanent_province
    if perm_province then perm_province.province_desc else 'no perm province set' end
  end
  
  def permanent_province_short
    if perm_province then perm_province.province_shortDesc else 'no perm province set' end
  end
  
  def permanent_country
    if perm_country then perm_country.country_desc else 'no perm country set' end
  end
  
  def permanent_country_short
    if perm_country then perm_country.country_shortDesc else 'no perm country set' end
  end

  def permanent_postal_code
    self.person_pc
  end
  
  def local_phone
    self.person_local_phone
  end
  
  def local_address
    self.person_local_addr
  end
  
  def local_city
    self.person_local_city
  end
  
  def local_postal_code
    self.person_local_pc
  end
  
  def local_province
    if loc_province  then loc_province.province_desc else 'no local province set' end
  end
  
  def local_province_short
    if loc_province then loc_province.province_shortDesc else 'no local province set' end
  end

  def local_country
    if loc_country then loc_country.country_desc else 'no local country set' end
  end

  def local_country_short
    if loc_country then loc_country.country_shortDesc else 'no local country set' end
  end
end
