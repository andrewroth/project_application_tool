class FeedbackMailer < ActionMailer::Base

  def forward(feedback)
    @subject          = 'SPT - FeebackMailer'
    @body             = { :feedback => feedback }
    @recipients       = $sp_email_only
    @from             = 'spt_feedbackmailer@campusforchrist.org'
    @sent_on          = Time.now
    @headers          = { 'Reply-To' => (!feedback.viewer.person ? 'unknown-email' : feedback.viewer.person.person_email) }
  end
end
