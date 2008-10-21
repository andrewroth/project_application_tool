require File.dirname(__FILE__) + '/../spec_helper'

describe AcceptanceController do
  it "should not allow submitting" do

    request.env["HTTP_REFERER"] = 'test.host/referrer'

    session[:user_id] = 1
    session[:event_group_id] = 1

    @eg = mock("eg", :empty? => false, :default_text_area_length => nil)

    @form = mock("form", :questionnaire => mock('questionnaire', :filter= => nil, :pages => []), :event_group => @eg, :title => 'a form')

    @appln = mock("appln", :form => @form)

    @viewer = mock("viewer", { 
      :project_director_projects => [],
      :project_administrator_projects => [],
      :support_coach_projects => [],
      :project_staff_projects => [],
      :processor_projects => [],
      :is_student? => false,
      :is_projects_coordinator? => false,
      :name => 'Bob'
    } )

    @project = mock("project")

    @profile = mock("profile", :id => 1, :appln => @appln, :viewer => @viewer, :project => @project, :profile => @profile)
    @appln.stub!(:profile => @profile)

    Profile.stub!(:find).and_return(@profile)
    Viewer.stub!(:find).and_return(@viewer)
    EventGroup.stub!(:find).and_return(@eg)

    get :submit, :profile_id => 1

    flash[:notice].should_not be_nil
    response.should redirect_to('http://test.hosttest.host/referrer')
  end
end
