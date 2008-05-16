class Withdrawn < Profile
  belongs_to :appln
  belongs_to :withdrawn_by, :class_name => "Viewer",
    :foreign_key => :withdrawn_by,
    :include => :persons
  belongs_to :reason_for_withdrawal, :foreign_key => 'reason_id'

  acts_as_state_machine :initial => :started, :column => :status

  state :admin_withdrawn

  state :declined, :enter => Proc.new {|profile|
                              }

  state :self_withdrawn, :enter => Proc.new{ |profile|
                                SpApplicationMailer.deliver_withdrawn(profile.appln)
                              }
  state :uninitialized

  state :staff_profile_dropped

  event :decline do
    transitions :to => :declined, :from => :uninitialized
  end

  event :self_withdraw do
    transitions :to => :self_withdrawn, :from => :uninitialized
  end
  
  event :admin_withdraw do
    transitions :to => :admin_withdrawn, :from => :uninitialized
  end

  event :drop_staff_profile do
    transitions :to => :staff_profile_dropped, :from => :uninitialized
  end

  def reason() r_o = reason_for_withdrawal; r_o ? r_o.blurb : '' end

  def initialize_state(options = {})
    self[:status] = 'uninitialized' # force each status change to go from uninitialized
    save!
    
    want_status = options[:status].to_sym
    if want_status == :declined
      self.decline!
    elsif want_status == :self_withdrawn
      self.self_withdraw!
    elsif want_status == :staff_profile_dropped
      self.drop_staff_profile!
    elsif want_status == :admin_withdrawn
      self.admin_withdraw!
    end
    
    self[:withdrawn_by] = options[:setter_id]
    if options[:old_class].to_s.downcase != 'withdrawn'
      self[:class_when_withdrawn] = options[:old_class]
      self[:status_when_withdrawn] = options[:old_status]
    end

    self.withdrawn_at = Time.now

    save!
  end
end
