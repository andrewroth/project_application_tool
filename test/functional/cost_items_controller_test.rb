require File.dirname(__FILE__) + '/../test_helper'
require 'cost_items_controller'

# Re-raise errors caught by the controller.
class CostItemsController; def rescue_action(e) raise e end; end

class CostItemsControllerTest < Test::Unit::TestCase
  fixtures :cost_items, :profiles, :applns, :projects

  def setup
    @controller = CostItemsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = cost_items(:first).id
    setup_spt
  end

  def test_index
    @request.session[:user_id] = $viewers['superadmin']
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    @request.session[:user_id] = $viewers['superadmin']
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:cost_items)
  end

  def test_show
    @request.session[:user_id] = $viewers['superadmin']
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:cost_item)
    assert assigns(:cost_item).valid?
  end

  def test_create
    num_cost_items = @eg.cost_items.count

    @request.session[:user_id] = $viewers['superadmin']
    post :create, :cost_item => {}

    assert_response :success

    assert_equal num_cost_items + 1, @eg.cost_items.count
  end

  def test_edit
    @request.session[:user_id] = $viewers['superadmin']
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:cost_item)
    assert assigns(:cost_item).valid?
  end

  def test_update
    @request.session[:user_id] = $viewers['superadmin']
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      CostItem.find(@first_id)
    }

    @request.session[:user_id] = $viewers['superadmin']
    post :destroy, :id => @first_id
    assert_response :success

    assert_raise(ActiveRecord::RecordNotFound) {
      CostItem.find(@first_id)
    }
  end
end
