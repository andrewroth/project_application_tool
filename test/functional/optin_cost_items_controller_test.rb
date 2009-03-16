require File.dirname(__FILE__) + '/../test_helper'
require 'optin_cost_items_controller'

# Re-raise errors caught by the controller.
class OptinCostItemsController; def rescue_action(e) raise e end; end

class OptinCostItemsControllerTest < Test::Unit::TestCase
  fixtures "ciministry/accountadmin_viewer"
  fixtures :profiles, :cost_items, :optin_cost_items

  def setup
    @controller = OptinCostItemsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    setup_spt
    @request.session[:user_id] = $viewers['superadmin']
    @request.session[:event_group_id] = 1
  end

  def test_year_cost_item
    @request.session[:user_id] = 1
    @request.session[:event_group_id] = 1

    get :index, :profile_id => 1

    assert_response :success

    assert_not_nil assigns(:cost_items)
    assert_not_nil assigns(:cost_items).find{ |ci| ci.id == 3 } # year cost item (finds it through EG)
    assert_not_nil assigns(:cost_items).find{ |ci| ci.id == 1 } # profile cost item for John
    assert_nil assigns(:cost_items).find{ |ci| ci.id == 2 } # this is for Sean not John
  end

  def test_index
    get :index, :profile_id => 1

    output_html_response
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list, :profile_id => 1

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:cost_items)
  end
end
