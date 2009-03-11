require File.dirname(__FILE__) + '/../test_helper'
require 'appln_controller'

# Re-raise errors caught by the controller.
class ApplnController; def rescue_action(e) raise e end; end

class ApplnControllerTest < Test::Unit::TestCase
  fixtures "ciministry/accountadmin_viewer"
  fixtures :applns, :reference_instances, :reference_emails, :forms
  fixtures :profiles, :projects, :processors
  fixtures "questionnaire_engine/questionnaires"
  fixtures "questionnaire_engine/form_pages"
  fixtures "questionnaire_engine/form_questionnaire_pages"
  fixtures "ciministry/accountadmin_accessgroup"
  fixtures "ciministry/accountadmin_vieweraccessgroup"
  
  def setup
    @controller = ApplnController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @request.session[:event_group_id] = 1
  end
  
  # Replace this with your real tests.
  def test_preferences_validated
    @request.session[:user_id] = 1
    post :validate_page, {
      :appln_id => 1,
      :id => 1, 
      :answers => {
        "preference1_id" => "", 
        "preference2_id" => ""},
      :application => {
        "as_intern" => 0
      },
      :current_position => "1"
    }
    
    assert_not_nil assigns('current_page').errors.full_messages.find{ |error| 
      error == "Preference1 can't be blank."
    }
    assert_not_nil assigns('current_page').errors.full_messages.find{ |error| 
      error == "Preference2 can't be blank."
    }
  end
  
  def test_references
    @request.session[:user_id] = 1
    post :validate_page, {
      :appln_id => 1,
      :id => 1,
      "reference1" => 
          {"is_staff"=>"false", 
          "title"=>"", 
          "mail"=>"0", 
          "first_name"=>"", 
          "last_name"=>"", 
          "email"=>""},
        "reference3"=>{
          "is_staff"=>"false", 
          "title"=>"", "mail"=>"0", 
          "first_name"=>"", 
          "last_name"=>"", 
          "email"=>""
        },
        "reference3"=>{
          "is_staff"=>"false", 
          "title"=>"", 
          "mail"=>"0", 
          "first_name"=>"", 
          "last_name"=>"", 
          "email"=>""},
      :save_only=>false, 
      :no_save=>0, 
      :current_position => "2"
    }
    assert_response :success
  end
  
  def test_submit

    # first make sure it will pass validation
    @request.session[:user_id] = $viewers['keener']
    post :validate_page, {
      :appln_id => 2,
      :answers => {
        "preference1_id" => "1",
        "preference2_id" => "2"},
      :application => {
        "as_intern" => 0
      },
      :current_position => "1"
    }
    assert_response :success
    assert_equal 0, assigns['current_page'].errors.length
    
    @request.session[:user_id] = 2 # keener
    assert_equal "started", Appln.find(1).status
    get :submit, { :appln_id => 2, :current_position => 2, :next_page => 2 }
    assert_response :redirect # to reload all the links
    assert_equal "submitted", Appln.find(2).status
    
    assert_equal 1, Applying.find_all_by_status_and_id('submitted', 3).length
    assert_response :redirect
    # TODO: figure out how to follow the redirect when I have internet
    # follow_redirect!
#    assert_response :success
#    assert_tag :content => /Section:/
    
    # now delete a ref to get into unsubmitted stage
    @request.session[:user_id] = 2 # keener
    assert_equal "submitted", Appln.find(2).status
    get :delete_reference, { :appln_id => 2, :ref_id => 1, :current_position => 2, :next_page => 2 }
    output_html_response
    assert_response :redirect
    assert_equal "unsubmitted", Appln.find(2).status
    assert_equal 1, Applying.find_all_by_status_and_id('unsubmitted', 3).length
    
    # now submit again
    @request.session[:user_id] = 2 # keener
    assert_equal "unsubmitted", Appln.find(2).status
    get :submit, { :appln_id => 2, :current_position => 2, :next_page => 2 }
    assert_response :redirect
    assert_equal "submitted", Appln.find(2).status
    assert_equal 1, Applying.find_all_by_status_and_id('submitted', 3).length
  end

  def test_withdraw_student_valid
    # first make sure a student can withdraw his/her own app
    @request.session[:user_id] = 1
    id = 1
    get :withdraw, :appln_id => id
    assert_response :success
    assert_equal 'self_withdrawn', Appln.find(id).status
  end
  
  def test_withdraw_student_invalid
    # make sure that student cna't withdraw someone else's app
    id = 2
    get :withdraw, :id => id
    assert_response 302
    assert_not_equal 'withdrawn', Appln.find(id).status
  end
  
  def test_withdraw_processor_invalid
    # make sure that a processor can't unsubmit apps that he shouldn't be able to
    @request.session[:user_id] = $viewers['sean']
    id = 3 # bob's app pref 1 is 7
    get :withdraw, :appln_id => id
    assert @response.body =~ /no permission/
    assert_not_equal 'withdrawn', Appln.find(id).status
  end

  def test_always_editable_student
    # make sure that a student can view his always editable fields
    @request.session[:user_id] = 1
    id = 1
    get :view_always_editable, :appln_id => id
    assert_response :success
  end
  
  def test_always_editable_projects_coordinators
    # make sure that a processor can edit always-editable
    @request.session[:user_id] = $viewers['superadmin']
    id = 3 # bob's app pref 1 is 7
    get :view_always_editable, :appln_id => id
    assert_response :success
  end
  
  def test_always_editable_not_projects_coordinators
    # make sure that a processor can't edit always-editable that he shouldn't be able to
    @request.session[:user_id] = $viewers['sean']
    id = 3 # bob's app pref 1 is 7
    get :view_always_editable, :appln_id => id
    assert_response :success
    assert @response.body =~ /no permission/
  end
end
