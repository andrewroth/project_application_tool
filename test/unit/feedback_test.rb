require File.dirname(__FILE__) + '/../test_helper'
require 'feedback'

class FeedbackTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"
  
  fixtures :feedbacks

  include ActionMailer::Quoting

  def test_invalid_with_empty_attributes
    feedback = Feedback.new
    assert !feedback.valid?
    assert feedback.errors.invalid?(:description)
    assert feedback.errors.invalid?(:feedback_type)
  end

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/feedback/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
