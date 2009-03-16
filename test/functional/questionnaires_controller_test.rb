require File.dirname(__FILE__) + '/../test_helper'
require 'questionnaires_controller'

# Re-raise errors caught by the controller.
class QuestionnairesController; def rescue_action(e) raise e end; end

class QuestionnairesControllerTest < Test::Unit::TestCase
  def setup
    @controller = QuestionnairesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_skip_ensure_project_app_for_questionnaire
    @request.session[:user_id] = 3 # superadmin
    get :index, :id => 1
  end
end
