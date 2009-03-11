require File.dirname(__FILE__) + '/../test_helper'
require 'profile_travel_segments_controller'

# Re-raise errors caught by the controller.
class ProfileTravelSegmentsController; def rescue_action(e) raise e end; end

class ProfileTravelSegmentsControllerTest < Test::Unit::TestCase

  fixtures :travel_segments

  def setup
    @controller = ProfileTravelSegmentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user_id] = Viewer.find_by_viewer_userID('superadmin').id
    @request.session[:event_group_id] = 1
    setup_spt
  end
  
  def test_add_shortcut_order
    get :add_shortcut, :profile_id => 1
    assert (@response.body =~ /flight_no/) > (@response.body =~ /departure_city/)
  end

  #make sure that the right travel segments get filtered.
  def test_travel_segment_filter_correct
    post :filter_travel_segments, {:flight_num => "AC", :profile_id => 1}
    assigns(:unassigned_ts).each {|ts|
      assert ts.flight_no =~ /.*AC.*/i
    }
    post :filter_travel_segments, {:arrival_city => "Vancouver", :profile_id => 1}
    assigns(:unassigned_ts).each {|ts|
      assert ts.arrival_city =~ /.*Vancouver.*/i
    }
    post :filter_travel_segments, {:departure_city => "Vancouver", :profile_id => 1}
    assigns(:unassigned_ts).each {|ts|
      assert ts.departure_city =~ /.*Vancouver.*/i
    }
    post :filter_travel_segments, {:arrival_time => "5", :profile_id => 1}
    assigns(:unassigned_ts).each {|ts|
      assert format_datetime(ts.arrival_time,:ts) =~ /.*5.*/i
    }
    post :filter_travel_segments, {:carrier => "WJ", :profile_id => 1}
    assigns(:unassigned_ts).each {|ts|
      assert ts.carrier =~ /.*WJ.*/i
    }
    post :filter_travel_segments, {:departure_date => "15", :profile_id => 1}
    assigns(:unassigned_ts).each {|ts|
      assert format_datetime(ts.departure_time,:ts) =~ /.*15.*/i
    }
    post :filter_travel_segments, {:notes => "segment", :profile_id => 1}
    assigns(:unassigned_ts).each {|ts|
      assert ts.notes =~ /.*segment.*/i
    }
  end
  
  #make sure that we don't get an application error from any special characters used in the filter
  def test_travel_segment_params_prepared
    post :filter_travel_segments, {:flight_num => "()[]{}.*!@#^&-_=+;:'?.>,\$%<|`~", :profile_id => 1}
    assert :success
    post :filter_travel_segments, {:arrival_city => "()[]{}.*!@#^&-_=+;:'?.>,\$%<|`~", :profile_id => 1}
    assert :success
    post :filter_travel_segments, {:arrival_date => "()[]{}.*!@#^&-_=+;:'?.>,\$%<|`~", :profile_id => 1}
    assert :success
    post :filter_travel_segments, {:carrier => "()[]{}.*!@#^&-_=+;:'?.>,\$%<|`~", :profile_id => 1}
    assert :success
    post :filter_travel_segments, {:departure_city => "()[]{}.*!@#^&-_=+;:'?.>,\$%<|`~", :profile_id => 1}
    assert :success
    post :filter_travel_segments, {:notes => "()[]{}.*!@#^&-_=+;:'?.>,\$%<|`~", :profile_id => 1}
    assert :success
    post :filter_travel_segments, {:departure_date => "()[]{}.*!@#^&-_=+;:'?.>,\$%<|`~", :profile_id => 1}
    assert :success
  end
end
