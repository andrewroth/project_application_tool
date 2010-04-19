class Person < ActiveRecord::Base
  load_mappings
  include Common::Core::Person
  include Common::Core::Ca::Person

  # this overrides the has_many :campsues :through => :campus_involvements
  has_many :campuses, :through => :assignments, :source => :campus

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
  def campus() hrdb_student_campus end
  def name() full_name end
  def email() person_email end

  def viewer
    viewers[0]
  end
  
  def campus_shortDesc(o = {})
    self.campus(o) ? self.campus(o).campus_shortDesc : ''
  end
  
  def campus_longDesc(o = {})
    self.campus(o) ? self.campus(o).campus_desc : ''
  end
end
