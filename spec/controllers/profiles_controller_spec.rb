require File.dirname(__FILE__) + '/../spec_helper'

describe ProfilesController do

  before do 
    session[:cas_sent_to_gateway] = true # make cas think it's already gone to the server to avoid redirect
    @viewer = mock_model(Viewer, :id => 1, :viewer_userID => "copter", :viewer_passWord => "9cdfb439c7876e703e307864c9167a15",
                        :viewer_isActive= => 1, :viewer_lastLogin= => Time.now, :save! =>'', :person =>'', :is_student? => false,
                        :is_eventgroup_coordinator? => true, :is_projects_coordinator? => true)
    Viewer.stub!(:find).and_return(@viewer)
    @event_group = mock_model(EventGroup, :id => 1, :title => '', :empty? => false, :logo => "a", :projects=>[], :prep_items =>[])
    EventGroup.stub!(:find).and_return(@event_group)
    @project = mock_model(Project, :id => 1, :find_all_by_hidden => [@project], :collect =>[])
    Project.stub!(:find).and_return(@project)
    Project.stub!(:event_group).and_return(@event_group)
    @event_group.stub!(:projects).and_return(@project)
    session[:user_id] = @viewer.id
    session[:event_group_id]=1
    @profile = mock_model(Profile, :id => 1, :description => '', :type => '', :amount => 1, :optional => true, :update_attributes =>self, :find => self,
                            :delete_if => '', :update_attributes => self, :destroy => nil)
    Profile.stub!(:find).and_return(@profile)
    Profile.stub!(:project).and_return(@project)
    @event_group.stub!(:profiles).and_return([@profile])
    @params = {}
  end
  
  it "should create new profile" do
    post 'create', :profile=>@params
    response.should_be success
  end
  
  it "should update profile" do
      post 'update', :profile => @params, :id => 1
      flash[:notice].should eql('Profile was successfully updated.')
    end
    
    it "should destroy profile" do
      @profile.destroy
      response.should be_success
    end
    
    it "should create new profile" do
      post 'new'
      @profile.should_be new_record
    end
    
    it "should render list" do
      post 'index'
      response.should redirect_to('list')
    end
    
    it "should set costing" do
      post 'costing'
      assigns[:submenu_title].should eql('costing')
    end
    
end