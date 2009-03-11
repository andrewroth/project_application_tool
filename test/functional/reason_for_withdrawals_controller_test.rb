require File.dirname(__FILE__) + '/../test_helper'
require 'reason_for_withdrawals_controller'

# Re-raise errors caught by the controller.
class ReasonForWithdrawalsController; def rescue_action(e) raise e end; end

class ReasonForWithdrawalsControllerTest < Test::Unit::TestCase
  fixtures :reason_for_withdrawals

  def setup
    @controller = ReasonForWithdrawalsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @request.session[:user_id] = 3
    @request.session[:event_group_id] = 1
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:reason_for_withdrawals)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_reason_for_withdrawal
    old_count = ReasonForWithdrawal.count
    post :create, :reason_for_withdrawal => { }
    assert_equal old_count+1, ReasonForWithdrawal.count
    
    assert_redirected_to reason_for_withdrawal_path(assigns(:reason_for_withdrawal))
  end

  def test_should_show_reason_for_withdrawal
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_reason_for_withdrawal
    put :update, :id => 1, :reason_for_withdrawal => { }
    assert_redirected_to reason_for_withdrawal_path(assigns(:reason_for_withdrawal))
  end
  
  def test_should_destroy_reason_for_withdrawal
    old_count = ReasonForWithdrawal.count
    delete :destroy, :id => 1
    assert_equal old_count-1, ReasonForWithdrawal.count
    
    assert_redirected_to reason_for_withdrawals_path
  end
end
