class ReferenceMailer < ActionMailer::Base
  def get_text_for_body(type)
    @appln.form.event_group.reference_emails.find_by_email_type(type).text
  end
end