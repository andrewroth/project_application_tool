require File.dirname(__FILE__) + '/../test_helper'
require 'manage_projects_controller'

# Re-raise errors caught by the controller.
class ManageProjectsController; def rescue_action(e) raise e end; end

class ManageProjectsControllerTest < Test::Unit::TestCase
  fixtures :applns, :projects, :forms
  fixtures "questionnaire_engine/questionnaires"
  fixtures "ciministry/accountadmin_accessgroup"
  fixtures "ciministry/accountadmin_viewer"
  fixtures "ciministry/accountadmin_vieweraccessgroup"

  def setup
    @controller = ManageProjectsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    setup_spt
  end
  
  def test_truth
    get :index
  end
end
