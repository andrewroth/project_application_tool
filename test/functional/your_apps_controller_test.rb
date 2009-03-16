require File.dirname(__FILE__) + '/../test_helper'
require 'your_apps_controller'

# Re-raise errors caught by the controller.
class YourAppsController; def rescue_action(e) raise e end; end

class YourAppsControllerTest < Test::Unit::TestCase
  # need this or else I get the decrement_open_transactions error
  self.use_transactional_fixtures = false
  
  fixtures "ciministry/accountadmin_viewer"
  fixtures :applns, :projects, :forms
  fixtures "questionnaire_engine/questionnaires"
  fixtures "ciministry/accountadmin_accessgroup"
  fixtures "ciministry/accountadmin_vieweraccessgroup"
  
  def setup
    @controller = YourAppsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    setup_spt
  end
  
  def test_apply
    user_id = 4 # user 'starter'
    applns_before = Appln.find_all_by_viewer_id(user_id).length
    assert_equal Appln.find_all_by_viewer_id(user_id).length, 0
    
    @request.session[:user_id] = user_id # starter
    get :apply, :id => 1
    
    assert_equal Appln.find_all_by_viewer_id(user_id).length, 1
    assert_response :redirect
    assert_not_nil assigns["appln"]
    assert_equal assigns["appln"].viewer_id, user_id
    assert_equal assigns["appln"].form_id, 1
    
    # this should pull the existing one out
    @request.session[:user_id] = user_id # starter
    get :apply, :id => 1
    
    assert_equal Appln.find_all_by_viewer_id(user_id).length, 1
  end
  
  def test_accepted
    appln = Appln.find(1)
    appln.status = "accepted"
    appln.save!
    Acceptance.create :appln_id => appln.id, :project_id => 1, 
      :support_coach_id => 1
    
    @request.session[:user_id] = 1
    get :list
    
    assert_tag :content => /Your application has been accepted/, 
      :descendant => {
        :content => /Afghanistan Project/
    }
    assert_no_tag :content => /You can start the following applications/, 
      :descendant => {
        :content => /Project Application/
    }
  end
end
