require File.dirname(__FILE__) + '/../spec_helper'

describe AcceptanceController do
  it "should not allow deleting references" do

    request.env["HTTP_REFERER"] = 'test.host/referrer'

    setup_eg; setup_form; setup_viewer; setup_project

    @appln = mock("appln", :form => @form)
    @profile = mock("profile", :id => 1, 
         :appln => @appln, 
         :viewer => @viewer, 
         :project => @project, 
         :profile => @profile)
    @appln.stub!(:profile => @profile)

    Profile.stub!(:find).and_return(@profile)

    get :delete_reference, :profile_id => 1

    flash[:error].should_not be_nil
    response.should redirect_to('http://test.hosttest.host/referrer')
  end

  it "should not allow submitting" do

    request.env["HTTP_REFERER"] = 'test.host/referrer'

    setup_eg; setup_form; setup_viewer; setup_project

    @appln = mock("appln", :form => @form)
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

  def setup_for_bulk
    @acceptance1 = mock("profile", :id => 1, 
         :appln => mock("appln", :form => @form), 
         :viewer => @viewer, 
         :class => Acceptance,
         :id => 1
    )
    @acceptance2 = mock("profile", :id => 1, 
         :appln => mock("appln", :form => @form), 
         :viewer => @viewer, 
         :class => Acceptance,
         :id => 2
    )
  end

  it "should print all bulk summary forms" do

    setup_eg; setup_form; setup_viewer; setup_project
    setup_for_bulk;

    Acceptance.stub!(:find_all_by_project_id).and_return([ @acceptance1, @acceptance2 ])

    get :bulk_summary_forms, :profile_id => 'all', :project_id => 1

    assigns[:instances].should_not be_nil
    assigns[:instances].length.should be(2)
  end

  it "should print a specific viewer's summary form" do

    setup_eg; setup_form; setup_viewer; setup_project
    setup_for_bulk;

    Acceptance.stub!(:find_all_by_viewer_id_and_project_id).and_return([ @acceptance2 ])

    get :bulk_summary_forms, :viewer_id => 2, :profile_id => 'all', :project_id => 1

    assigns[:instances].should_not be_nil
    assigns[:instances].length.should be(1)
  end


end
