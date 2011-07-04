class Applying < Profile
  belongs_to :appln

  belongs_to :locked_by, :class_name => "Viewer",
    :foreign_key => :locked_by

  acts_as_state_machine :initial => :started, :column => :status
  
  # State machine stuff
  state :started

  state :submitted, :enter => Proc.new {|p|
                                app = p.appln
                                app.submitted_at = Time.now
                                app.save!
                                unless app.reference_instances.empty? && p.project.event_group.automatic_acceptance
                                  SpApplicationMailer.deliver_submitted(app)
                                end
                              }
  
  state :completed, :enter => Proc.new {|p|
                                app = p.appln

				p.completed_at = Time.now
				p.save!

                                unless app.reference_instances.empty? && p.project.event_group.automatic_acceptance
                                  SpApplicationMailer.deliver_completed(app)
                                end
                              }

  state :unsubmitted, :enter => Proc.new {|p|
                                app = p.appln
                                app.unsubmit_email
                              }

  event :submit do
    transitions :to => :submitted, :from => :started
    transitions :to => :submitted, :from => :unsubmitted
  end

  event :unsubmit do
    transitions :to => :unsubmitted, :from => :submitted
  end

  event :complete do
    transitions :to => :completed, :from => :submitted
    transitions :to => :completed, :from => :started
  end

  def initialize_state(params = {})
    if params[:status] == :completed
      self.completed_at ||= Time.now
      self.save!
    end

    if params[:status] == :submitted || params[:status] == :completed
      app = self.appln
      app.submitted_at ||= Time.now
      app.save!
    end
  end
end

