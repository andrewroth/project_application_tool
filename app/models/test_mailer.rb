class TestMailer < ActionMailer::Base

  def test(subject, body, to, from)
    @subject          = subject
    @body             = { :content => body }
    @recipients       = "John Smith <#{to}>"
    @from             = from
    @sent_on          = Time.now
    @headers          = { 'Reply-To' => from }
  end
end
