require File.dirname(__FILE__) + '/../test_helper'
require_or_load 'elements_controller'

# Re-raise errors caught by the controller.
class ElementsController; def rescue_action(e) raise e end; end

class ElementsControllerTest < Test::Unit::TestCase
  def setup
    @controller = ElementsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    setup_spt
  end

  # Replace this with your real tests.
  def test_new
    get :new, :questionnaire_id => 1, :page_id => 1, :id => 1
    assert_response :success
  end
  def test_new
    post :create, :questionnaire_id => 1, :page_id => 1, 
                  :commit => 'Create Element',
                  :element_type => 'Heading',
                  :element => { 'text' => 'test' }
    assert_response :redirect
  end
end
