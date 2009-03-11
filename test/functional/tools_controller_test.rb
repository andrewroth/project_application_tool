require File.dirname(__FILE__) + '/../test_helper'
require 'tools_controller'

# Re-raise errors caught by the controller.
class ToolsController; def rescue_action(e) raise e end; end

class ToolsControllerTest < Test::Unit::TestCase
  def setup
    @controller = ToolsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    setup_spt
  end

  # Replace this with your real tests.
  def test_truth
    get :update_motivation_codes
  end
end
