class ReferenceInstance < ActiveRecord::Base
  load 'md5.rb'
  
  has_many :answers, :foreign_key => :instance_id
  belongs_to :reference
  
  before_create :generate_access_key
  
  # state machine
  acts_as_state_machine :initial => :created, :column => :status
  
  state :bypassed, :enter => Proc.new {|ref|
                                send_hook :completed, ref
                                ref.status = 'completed'
                                ref.save!
                              }
  state :started
  state :created
  state :completed, :enter => Proc.new {|ref| 
                                ref.submitted_at = Time.now
                                ReferenceMailer.deliver_completed(ref) if !ref.mail # message to reference
                                ReferenceMailer.deliver_completed_confirmation(ref) # notify candidate
                                send_hook :completed, ref
                              }
  
  event :bypass do
    transitions :to => :bypassed, :from => :created
    transitions :to => :bypassed, :from => :started
  end

  event :start do   # start!
    transitions :to => :started, :from => :created
  end

  event :submit do  # submit!
    transitions :to => :completed, :from => :started
    transitions :to => :completed, :from => :bypassed
  end
  # end of state machine
  
  def reference_instances() [] end

  def questionnaire
    self.reference.questionnaire
  end

  def name
    self.reference.text
  end
  
  def pdf
    ""
  end
  
  def frozen?
    !%w(started).include?(self.status)
  end
  
  def save_answer(person, params, answers)
    #save answer doesn't do anything. Exists for completeness. Remove it and die
  end
  
  # access key for email link
  def generate_access_key
    self.access_key = MD5.hexdigest((object_id + Time.now.to_i).to_s)
  end
  
  def validate!(page, instance)
    ref = reference(instance)
    errors = []
    ['title','first_name','last_name'].each do |col|
      # we need to get the reference element from the application. "self" refers to a page
      # element, not the actual reference.
      if ref
        errors << col.titleize + " is required." if ref[col].nil? || ref[col] == ''
      end
    end
    unless ref.mail?
      unless ref.valid_email?
        errors << "Email address is invalid"
      end
    end
    unless errors.empty?
      page.errors.add_to_base("<strong>"+self.name+":</strong>")
    end
    errors.each do |error|
      page.errors.add_to_base(error)
    end
    page.add_invalid_element(self) unless page.errors.empty?
  end
  
  def get_answer(instance) end
  
  def valid_email?(ref = self)
    return nil if self.email.nil?
    self.email =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  end
  
  def ref_url
    "#{$server_url}/reference_instances?id=#{id}&key=#{access_key}"
  end
  
  def send_invitation
    if valid_email?
      ReferenceMailer.deliver_invitation(self, ref_url)
      ReferenceMailer.deliver_invitation_confirmation(self)
      self.email_sent_at = Time.now
      self.save
    end
  end
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
  # Stuff for questionnaire engine
  # def element_type() 'Reference'; end
  # def elements() []; end
  # def parent() nil; end
  
  def self.questionnaire()
    @questionnaire ||= Questionnaire.find_by_title(self.name, :include => :pages, :order => :position)
  end
  
  def deep_copy()
    e = Element.create
    e[:type] = self.class.name
    e[:parent_id] = self[:parent_id]
    e.save!
    e
  end

  def submitted?() self.completed? end
  def email_sent?() !self.email_sent_at.nil? end

  def self.send_hook(m, reference_instance)
    hook_m = :"entered_#{m.to_s}"
    reference_instance.send(hook_m) if reference_instance.respond_to?(hook_m)
  end
end
