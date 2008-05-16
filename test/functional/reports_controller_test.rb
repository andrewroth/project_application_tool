$year = 2007

require File.dirname(__FILE__) + '/../test_helper'
require 'reports_controller'

# Re-raise errors caught by the controller.
class ReportsController; def rescue_action(e) raise e end; end

class ReportsControllerTest < Test::Unit::TestCase
  fixtures "ciministry/accountadmin_viewer"
  fixtures :applns, :reference_instances, :profiles
  fixtures :reference_emails, :forms, :projects, :cost_items
  fixtures :travel_segments, :profile_travel_segments
  fixtures "questionnaire_engine/questionnaires"
  fixtures "questionnaire_engine/form_pages"
  fixtures "questionnaire_engine/form_questionnaire_pages"
  fixtures "ciministry/accountadmin_accessgroup"
  fixtures "ciministry/accountadmin_vieweraccessgroup"
  fixtures :event_groups

  def setup
    @controller = ReportsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    setup_spt
  end
  
  def test_index
    test_report_success :index
    # better not be any un-initialized links
    assert_nil @response.body["[ ], [ ]);"]
  end
  
  def test_registrants
    test_report_success :registrants, :project_id => 'all'
  end
  
  def test_project_participants
    test_report_success :project_participants, :project_id => 'all'
  end
  
  def test_cm
    test_report_success :cm
  end
  
  def test_ticketing_requests
    test_report_success :ticketing_requests, :project_id => 'all'
  end
  
  def test_crisis_management
    test_report_success :crisis_management, :project_id => 'all'
  end
  
  def test_project_stats
    test_report_success :project_stats
  end
  
  def test_parental_emails
    test_report_success :parental_emails, :project_id => 'all'
  end
  
  def test_funding_status
    test_report_success :funding_status, :project_id => 'all'

    # test target != 0
    assert_not_equal 0, assigns(:participants).find{ |p| p[0] == "Fname_john.calvin Lname_john.calvin" }[6].to_i
  end
  
  def test_funding_details
    test_report_success :funding_details, :project_id => 'all', :viewer_id => 1
    test_report_success :funding_details, :project_id => 'all', :viewer_id => $viewers['sean']
  end
  
  def test_funding_costs
    test_report_success :funding_costs, :project_id => 'all', :viewer_id => $viewers['sean']
  end
  
  def test_project_paperwork
    test_report_success :project_paperwork
  end

  def test_travel_list
    test_report_success :travel_list, :project_id => 'all'
  end
  
  def test_travel_segment
    test_report_success :travel_segment, :travel_segment_id => 1
  end

  def test_itinerary
    test_report_success :travel_segment, :travel_segment_id => 1

    # test personal notes duplicated
    get :itinerary, :project_id => 'all'
    assert_equal 2, @response.body.split("johncalvin's personal notes").size
  end

  # returns a select list with viewers who are accepted to the projects given
  def test_accepted_viewers_for_project
    test_report_success :viewers_with_profile_for_project, :project_id => 'all'
  end
  
  protected
  
  def test_report_success(report, *params)
    @request.session[:user_id] = Viewer.find_by_viewer_userID('superadmin').id
    if params.empty?
      params = {}
    else
      params = params[0]
    end
    
    test_html report, params
    test_csv report, params
  end
  
  def test_html(report, params)
    get report, params
    assert_response :success
  end
  
  def test_csv(report, params)
    get report, params.merge(:format => 'csv')
    assert_response :success
  end
end
