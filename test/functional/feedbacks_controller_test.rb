require File.dirname(__FILE__) + '/../test_helper'
require 'feedbacks_controller'

# Re-raise errors caught by the controller.
class FeedbacksController; def rescue_action(e) raise e end; end

class FeedbacksControllerTest < Test::Unit::TestCase
  fixtures :feedbacks
  fixtures "ciministry/accountadmin_viewer"

  def setup
    @controller = FeedbacksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = feedbacks(:comment).id
  end

  def test_list_without_user
    get :list
    assert_redirected_to( :controller => "security", :action => "login" )
  end
  
  def test_new_without_user
    get :new
    assert_redirected_to( :controller => "security", :action => "login" )
  end

  def test_show_without_user
    get :show
    assert_redirected_to( :controller => "security", :action => "login" )
  end

  def test_new_with_user
    @request.session[:user_id] = 3 # superadmin
  end
  
  def test_list_with_user
    assert true
  end
  
  def test_show_with_user
    assert true
  end
  
  def test_destroy_with_user
    assert true
  end
end
