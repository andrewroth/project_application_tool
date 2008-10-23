require File.dirname(__FILE__) + '/../spec_helper'

describe AcceptanceController do
  it "should not allow submitting" do

    request.env["HTTP_REFERER"] = 'test.host/referrer'

    setup_eg; setup_form; setup_viewer

    @appln = mock("appln", :form => @form)
    @project = mock("project")
    @profile = mock("profile", :id => 1, 
         :appln => @appln, 
         :viewer => @viewer, 
         :project => @project, 
         :profile => @profile)
    @appln.stub!(:profile => @profile)

    Profile.stub!(:find).and_return(@profile)

    get :submit, :profile_id => 1

    flash[:notice].should_not be_nil
    response.should redirect_to('http://test.hosttest.host/referrer')
  end
end
