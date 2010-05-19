require File.dirname(__FILE__) + '/../spec_helper'

describe ViewersController do

  before do 
    @staff_viewer = stub_viewer_as_staff
    stub_viewer_as_projects_coordinator
    stub_event_group
    stub_project
    stub_profile
    stub_appln
    setup_login
    Viewer.roles.each do |role| @staff_viewer.stub!("all_#{role.to_s.pluralize}", []) end
  end

  it "should render deactivate get" do
    get :deactivate, :id => @viewer.id
    response.should be_success
    assigns('accesses').first.name.should == "ProjectsCoordinator_1001"
  end

  it "should revoke an access" do
    @ps = mock_model(ProjectStaff, :id => 111)
    stub_model_find(:ps)
    @ps.should_receive(:end_date=).with(Date.today)
    @ps.should_receive(:save!)
    post :deactivate, :id => @staff_viewer.id, :revoke => { "ProjectStaff_111" => "1" }
  end

  it "should reinstate an access" do
    @ps = mock_model(ProjectStaff, :id => 111)
    stub_model_find(:ps)
    @ps.should_receive(:end_date=).with(nil)
    @ps.should_receive(:save!)
    post :deactivate, :id => @staff_viewer.id, :reinstate => { "ProjectStaff_111" => "1" }
  end
end 
