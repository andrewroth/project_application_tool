require File.dirname(__FILE__) + '/../test_helper'
require 'acceptance_controller'

# Re-raise errors caught by the controller.
class AcceptanceController; def rescue_action(e) raise e end; end

class AcceptanceControllerTest < Test::Unit::TestCase
  fixtures "ciministry/accountadmin_viewer"
  fixtures :applns, :projects, :forms, :profiles
  fixtures "questionnaire_engine/questionnaires"
  fixtures "ciministry/accountadmin_accessgroup"
  fixtures "ciministry/accountadmin_vieweraccessgroup"
  
  def setup
    @controller = AcceptanceController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    setup_spt
  end
  
  def test_update_support_coach
    @request.session[:user_id] = 1 # john.calvin
    @request.session[:event_group_id] = 1

    get :update_support_coach, :profile_id => 1, :support_coach_id => 2
    assert_response :redirect # to students controller
    # user_id 1 is john calvin, a student, so he should
    # be restricted and no change
    assert_equal 6, Acceptance.find(1).support_coach_id
    
    @request.session[:user_id] = 3 # superadmin
    get :update_support_coach, :profile_id => 1, :support_coach_id => 2
    assert_response :redirect # back to your_projects
    # user_id 3 is superadmin, so should change
    assert_equal 2, Acceptance.find(1).support_coach_id
    
    @request.session[:user_id] = 5 # greg
    get :update_support_coach, :profile_id => 1, :support_coach_id => 3
    # greg is a staff but not able to change the
    # support coach, he's not assigned to this project
    assert_equal 2, Acceptance.find(1).support_coach_id
  end
end
