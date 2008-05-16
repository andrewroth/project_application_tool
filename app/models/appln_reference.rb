class ApplnReference < ReferenceInstance
  belongs_to :instance, :class_name => 'Appln', :foreign_key => :instance_id

  def entered_completed
    instance.complete(self) # is the whole app complete now?
  end

  def viewer
    instance.viewer
  end

  def outgoing_email
    instance.profile.project.event_group.outgoing_email 
  end
end
