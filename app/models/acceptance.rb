class Acceptance < Profile
  belongs_to :appln
  belongs_to :support_coach, :class_name => "Viewer", :foreign_key => :support_coach_id
  
  acts_as_state_machine :initial => :accepted, :column => :status

  state :accepted, :enter => Proc.new {|p|
                                p.accepted_at = Time.now
				p.save!
                              }
  state :confirmed, :enter => Proc.new{ |p|
                                p.confirmed_at = Time.now
				p.save!
                              }
  state :uninitialized

  event :accept do
    transitions :to => :accepted, :from => :uninitialized
    transitions :to => :accepted, :from => :completed
  end

  event :confirm do
    transitions :to => :confirmed, :from => :uninitialized
    transitions :to => :confirmed, :from => :accepted
  end

#  has_many :support_coaches, :class_name => "Viewer", :through => :support_coach_entry,
#    :source => :support_coach_entry
#  # couldn't get this working... so defined a method to do it below
  
  def self.support_coach_none() 'admin choice' end
  def support_coach_none() self.class.support_coach_none end
  
  def support_coach_str
    sc = support_coach
    sc.nil? ? support_coach_none : sc.name
  end
  
  def costing(eg)
    calculate_sums(all_cost_items(eg))
  end

  def initialize_state(options = {})
    self[:status] = 'uninitialized'
    save!

    want_status = options[:status].to_sym
    if want_status == :accepted
      self.accept!
    elsif want_status == :confirmed
      self.confirm!
    elsif want_status == :withdrawn
      self.withdrawn_by = options[:setter_id]
      self.withdraw!
    end
    
    save!
  end
  
  def intern
    self.as_intern? ? 'intern' : ''
  end
  
  def project_title
    self.project.title
  end
  
end
