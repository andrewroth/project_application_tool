require File.dirname(__FILE__) + '/../test_helper'
require 'reference_emails_controller'

# Re-raise errors caught by the controller.
class ReferenceEmailsController; def rescue_action(e) raise e end; end

class ReferenceEmailsControllerTest < Test::Unit::TestCase
  def setup
    @controller = ReferenceEmailsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
