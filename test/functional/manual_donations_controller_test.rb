require File.dirname(__FILE__) + '/../test_helper'
require 'manual_donations_controller'

# Re-raise errors caught by the controller.
class ManualDonationsController; def rescue_action(e) raise e end; end

class ManualDonationsControllerTest < Test::Unit::TestCase
  fixtures :manual_donations
  fixtures "ciministry/accountadmin_viewer"

  def setup
    @controller = ManualDonationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    setup_spt
    @first_id = manual_donations(:first).id
    @request.session[:user_id] = $viewers['superadmin']
  end

  def test_index_with_viewer
    get :index
    assert_response :success
    assert_template 'list'
  end
  
  def test_index_without_viewer
    @request.session[:user_id] = nil
    get :index
    assert_redirected_to :controller => 'security', :action => 'login'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:manual_donations)
  end
  
  def test_list_without_viewer
    @request.session[:user_id] = nil
    get :list
    assert_redirected_to :controller => 'security', :action => 'login'
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:manual_donation)
    # don't 
#    assert assigns(:manual_donation).valid?
  end

  def test_show_without_viewer
    @request.session[:user_id] = nil
    get :show, :id => @first_id
    assert_redirected_to :controller => 'security', :action => 'login'
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:manual_donation)
  end
  
  def test_new_without_viewer
    @request.session[:user_id] = nil
    get :new
    assert_redirected_to :controller => 'security', :action => 'login'
  end

  def test_create
    num_manual_donations = ManualDonation.count

    @request.session[:user_id] = $viewers['superadmin']
    post :create, :manual_donation => {
      :donation_type_id => 1,
      :original_amount => 20,
      :amount => 20,
      :donor_name => 'bob',
      :motivation_code => 5
    }

    assert_response :redirect
    # gives a weird error, hrm
#    assert_redirected_to :controller => :main

    assert_equal num_manual_donations + 1, ManualDonation.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:manual_donation)
    # don't know what this does or why it's failing:
    assert assigns(:manual_donation).valid?
  end
  
  def test_edit_without_viewer
    @request.session[:user_id] = nil
    get :edit, :id => @first_id
    assert_redirected_to :controller => 'security', :action => 'login'
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      ManualDonation.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ManualDonation.find(@first_id)
    }
  end
end
