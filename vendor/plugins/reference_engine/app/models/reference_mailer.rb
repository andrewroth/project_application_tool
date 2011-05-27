class ReferenceMailer < ActionMailer::Base
  
  def invitation(reference, url)
    setup(reference)
    @body[:ref_url] = url
    @subject = 'Project Reference Invitation'
    @from = @instance.viewer.name + ' <' + @instance.viewer.email + '>'
    @appln = @instance
    render_from_email 'ref_request'
  end
  
  def invitation_confirmation(reference)
    setup(reference)
    @subject = 'Project Reference Invitation Confirmation'
    @recipients = "#{@instance.viewer.name} <#{@instance.viewer.email}>"
    @appln = @instance
    render_from_email 'ref_request_confirm'
  end
  
  def completed(reference)
    setup(reference)
    @subject = 'Project Reference Completed'
    @appln = @instance
    render_from_email 'ref_completed'
  end
  
  def completed_confirmation(reference)
    setup(reference)
    @subject = reference.full_name + ' completed your reference'
    @recipients = "#{@instance.viewer.name} <#{@instance.viewer.email}>"
    @appln = @instance
    render_from_email 'ref_completed_confirm'
  end
  
  def deleted(reference)
    setup(reference)
    @subject = 'Your reference is no longer required'
    @appln = @instance
    render_from_email 'ref_deleted'
  end
  
  protected
    def setup(reference)
      @subject = 'Application Reference'
      @recipients = "#{reference.full_name} <#{reference.email}>"
      @instance = reference.instance
      @from = reference.outgoing_email.to_s.empty? ? $sp_email : reference.outgoing_email
      @body = {:reference => reference,
               :applicant_name => @instance.viewer.name,
               :applicant_email => @instance.viewer.email,
               :applicant_phone => @instance.viewer.phone,
               :ref_first_name => reference.first_name,
               :ref_last_name => reference.last_name }
      content_type "text/html"
    end

    def render_from_email(type)
      body render(:inline => get_text_for_body(type), :body => @body)
    end
    
end
