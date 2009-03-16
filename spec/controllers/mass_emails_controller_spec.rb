require File.dirname(__FILE__) + '/../spec_helper'

describe MassEmailsController do
  def mock_profile(o)
    mock_model(o[:class].constantize, :viewer => mock('viewer', 
       :person => mock('person', :email => o[:email])),
       :class => o[:class],
       :status => o[:status],
       :class_when_withdrawn => o[:class_when_withdrawn]
    )
  end

  def setup2
    @viewer.stub!(:current_projects_with_any_role => [ @project ])
  end

  def setup3
    @viewer.stub!(:is_projects_coordinator? => true)
  end

  before do
    setup_eg; setup_viewer; setup_project; setup2
  end

  it "shouldn't crash on index" do
    get :index
  end

  it "should handle applying with one status" do
    Profile.should_receive(:find_all_by_type_and_project_id).and_return( [
      mock_profile(:email => 'started', :class => 'Applying', :status => 'started'),
      mock_profile(:email => 'submitted', :class => 'Applying', :status => 'submitted'),
      mock_profile(:email => 'completed', :class => 'Applying', :status => 'completed'),
    ] )
    get :emails, :project_id => @project.id, :applying_started => '1'
    assigns('result').should == 'started'
  end

  it "should handle applying with multiple status" do
    Profile.should_receive(:find_all_by_type_and_project_id).and_return( [
      mock_profile(:email => 'started', :class => 'Applying', :status => 'started'),
      mock_profile(:email => 'submitted', :class => 'Applying', :status => 'submitted'),
      mock_profile(:email => 'completed', :class => 'Applying', :status => 'completed'),
    ] )
    get :emails, :project_id => @project.id, :applying_started => '1', 'applying_submitted' => '1'
    assigns('result').should == 'started, submitted'
  end

  it "should not include withdrawn StaffProfiles from withdrawn list" do
    setup3
    Profile.should_receive(:find_all_by_type_and_project_id).and_return( [
      mock_profile(:email => 'withdrawn_staff', :class => 'Withdrawn', :status => 'started', :class_when_withdrawn => 'StaffProfile'),
      mock_profile(:email => 'withdrawn_app', :class => 'Withdrawn', :status => 'submitted', :class_when_withdrawn => 'Applying'),
    ] )
    get :emails, :project_id => @project.id, :withdrawn => '1'
    assigns('result').should == 'withdrawn_app'
  end

  it "should include withdrawn StaffProfiles from withdrawn list when Staff is also checked" do
    Profile.should_receive(:find_all_by_type_and_project_id).and_return( [
      mock_profile(:email => 'withdrawn_staff', :class => 'Withdrawn', :status => 'started', :class_when_withdrawn => 'StaffProfile'),
      mock_profile(:email => 'withdrawn_app', :class => 'Withdrawn', :status => 'submitted', :class_when_withdrawn => 'Applying'),
    ] )
    get :emails, :project_id => 'any', :withdrawn => '1', :staff => '1'
    assigns('result').should == 'withdrawn_staff, withdrawn_app'
  end
end
