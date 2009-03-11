require File.dirname(__FILE__) + '/../test_helper'
require 'travel_segments_controller'

# Re-raise errors caught by the controller.
class TravelSegmentsController; def rescue_action(e) raise e end; end

class TravelSegmentsControllerTest < Test::Unit::TestCase
  fixtures :travel_segments
  fixtures "ciministry/accountadmin_viewer"

  def setup
    @controller = TravelSegmentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = travel_segments(:oex1).id
    @request.session[:user_id] = $viewers['superadmin']
    setup_spt
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:travel_segments)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:travel_segment)
    assert assigns(:travel_segment).valid?
  end

  def test_create
    num_travel_segments = TravelSegment.count

    post :create, :travel_segment => {}

    assert_response :success

    assert_equal num_travel_segments + 1, TravelSegment.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:travel_segment)
    assert assigns(:travel_segment).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :success
  end

  def test_destroy
    assert_nothing_raised {
      TravelSegment.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :success

    assert_raise(ActiveRecord::RecordNotFound) {
      TravelSegment.find(@first_id)
    }
  end
end
