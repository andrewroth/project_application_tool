require File.dirname(__FILE__) + '/../test_helper'
require 'main_controller'

# Re-raise errors caught by the controller.
class MainController; def rescue_action(e) raise e end; end

class MainControllerTest < Test::Unit::TestCase
  fixtures "ciministry/accountadmin_viewer"
  fixtures "questionnaire_engine/questionnaires"
  fixtures "questionnaire_engine/form_pages"
  fixtures "questionnaire_engine/form_questionnaire_pages"
  fixtures "ciministry/accountadmin_accessgroup"
  fixtures "ciministry/accountadmin_vieweraccessgroup"
  fixtures "ciministry/cim_hrdb_access"
  fixtures "ciministry/cim_hrdb_assignment"
  fixtures "ciministry/cim_hrdb_person"
  fixtures "ciministry/cim_hrdb_campus"
  fixtures "ciministry/spt_ticket"
  fixtures :applns, :projects, :profiles, :forms, :processors
  
  def setup
    @controller = MainController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    setup_spt
    @request.session[:user_id] = $viewers['superadmin'] # let tests override this if they don't want it
  end
  
  def test_your_campuses
    get :your_campuses
    
    # make sure all campuses are shown
    assert_equal assigns['campuses'].length, Campus.find(:all).length
    
    @request.session[:user_id] = 5 # greg
    get :your_campuses
    
    # make sure all campuses are shows
    assert_equal Campus.find(:all).length, assigns['campuses'].length
  end
  
  def test_your_applications
    @request.session[:user_id] = 6 # sean
    get :your_applications
    assert_response :success
    assert assigns['processor_list']

    # set keener's 'applying' profile to true
    app = Applying.find 3
    app.status = 'completed'
    app.save!
    
    assert_equal 1, assigns['processor_list'].length # only keener (afgh) and bob (3) are done
                                                     # BUT because bob's is unsubmitted, it doesn't
                                                     # show up in the your projects list
    @request.session[:user_id] = $viewers['superadmin'] # let tests override this if they don't want it
    get :your_applications
    assert_response :success
    assert assigns['processor_list']
    assert_equal 2, assigns['processor_list'].length # keener (afgh), bob (3), and dude (7)
                                                     # again bob is unsubmitted, so doesn't show up
  end
  
  def test_staff_in_search
    post :get_viewer_specifics, {:id => 6}
    # todo
  end
end
