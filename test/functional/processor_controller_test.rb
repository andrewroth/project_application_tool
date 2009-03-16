require File.dirname(__FILE__) + '/../test_helper'
require 'processor_controller'

# Re-raise errors caught by the controller.
class ProcessorController; def rescue_action(e) raise e end; end

class ProcessorControllerTest < Test::Unit::TestCase
  def setup
    @controller = ProcessorController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    setup_spt
  end

  def test_view_entire
    @request.session[:user_id] = 3
    @request.session[:event_group_id] = 1

    get :view_entire, {
      :profile_id => 3, # profile 3
      :project_id => 1,
    }
    # redirect to acceptance controller
    assert_redirected_to :controller => 'acceptance', :action => 'view_entire'
  end
end
