require 'test_helper'

class ProfilePrepItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:profile_prep_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create profile_prep_item" do
    assert_difference('ProfilePrepItem.count') do
      post :create, :profile_prep_item => { }
    end

    assert_redirected_to profile_prep_item_path(assigns(:profile_prep_item))
  end

  test "should show profile_prep_item" do
    get :show, :id => profile_prep_items(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => profile_prep_items(:one).id
    assert_response :success
  end

  test "should update profile_prep_item" do
    put :update, :id => profile_prep_items(:one).id, :profile_prep_item => { }
    assert_redirected_to profile_prep_item_path(assigns(:profile_prep_item))
  end

  test "should destroy profile_prep_item" do
    assert_difference('ProfilePrepItem.count', -1) do
      delete :destroy, :id => profile_prep_items(:one).id
    end

    assert_redirected_to profile_prep_items_path
  end
end
