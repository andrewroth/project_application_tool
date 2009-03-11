require File.dirname(__FILE__) + '/../test_helper'
require 'event_groups_controller'

# Re-raise errors caught by the controller.
class EventGroupsController; def rescue_action(e) raise e end; end

class EventGroupsControllerTest < Test::Unit::TestCase
  fixtures :event_groups

  def setup
    @controller = EventGroupsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    setup_spt
    @request.session[:user_id] = $viewers['superadmin']
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:nodes)
  end

  def test_should_create_event_group
    old_count = EventGroup.count
    post :create, :event_group => { }
    assert_equal old_count+1, EventGroup.count
    
    assert_redirected_to event_groups_path
  end
 
  def test_should_destroy_event_group
    old_count = EventGroup.count
    delete :destroy, :id => 1
    assert_equal old_count-1, EventGroup.count
    
    assert_redirected_to event_groups_path
  end
end
