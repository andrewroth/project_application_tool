require File.dirname(__FILE__) + '/../spec_helper'

describe ProfilePrepItemsController do

  before do 
    session[:cas_sent_to_gateway] = true # make cas think it's already gone to the server to avoid redirect
    @viewer = mock_model(Viewer, :id => 1, :viewer_userID => "copter", :viewer_passWord => "9cdfb439c7876e703e307864c9167a15",
                        :viewer_isActive= => 1, :viewer_lastLogin= => Time.now, :save! =>'', :person =>'', :is_student? => false)
    Viewer.stub!(:find).and_return(@viewer)
    @event_group = mock_model(EventGroup, :id => 1, :empty? => false, :logo => "a", :projects=>[], :prep_items =>[])
    EventGroup.stub!(:find).and_return(@event_group)
    @project = mock_model(Project, :id => 1, :find_all_by_hidden => [@project], :collect =>[])
    Project.stub!(:find).and_return(@project)
    @event_group.stub!(:projects).and_return(@project)
    session[:user_id] = @viewer.id
    session[:event_group_id]=1
    
    @prep_item = mock_model(PrepItem, :id => 1, :title => '', :description => '', 
        :projects => mock('projects', :delete_all => []), :event_group_id= => 1, :errors => '', :applies_to => "year_item", 
        :individual => false, :deadline => '', :update_attributes => self, :destroy => self, :event_group= => nil, :event_group_id => nil)
    PrepItem.stub!(:find).and_return(@prep_item)
  end

  describe "valid profile prep item attributes" do
    
    before do
      @profile_prep_item = mock_model(ProfilePrepItem, :id => 1, :submitted => true, :received => true, :notes => '', :optional => true, 
                                      :update_attributes => self, :destroy => self, :find_or_create_by_prep_item_id => self)
      ProfilePrepItem.stub!(:find).and_return(@profile_prep_item)
      @profile = mock_model(Profile, :id => 1, :all_prep_items => [@prep_item], :profile_prep_items => @profile_prep_item)
      Profile.stub!(:find).and_return(@profile)
      @params = { :id => 1 }
    end
    
    it "should create new profile prep item" do
      post 'create', :profile_prep_item =>@params
      assigns[:profile_prep_item].should_not be_new_record
      flash[:error].should be_nil
      flash[:notice].should_not be_nil
    end
        
    it "should update profile prep item" do
      post 'update', :profile_prep_item => @params
      response.should be_success
    end
    
    it "should destroy profile prep item" do
      ProfilePrepItem.delete_all
      response.should be_success
    end
    
    it "should render index" do
      @profile_prep_item.should_receive(:save)
      post 'index'
      response.should be_success
      response.should render_template('index')
    end
    
  end
  
  describe "with invalid params" do
  
  before do
      @profile_prep_item = mock_model(ProfilePrepItem, :id => 1, :submitted => true, :received => true, :notes => '', :optional => true, 
                                      :update_attributes => nil, :destroy => self, :find_or_create_by_prep_item_id => self, :save => false)
      ProfilePrepItem.stub!(:find).and_return(@profile_prep_item)
      @profile = mock_model(Profile, :id => 1, :all_prep_items => [@prep_item], :profile_prep_items => @profile_prep_item)
      Profile.stub!(:find).and_return(@profile)
      ProfilePrepItem.stub!(:find).and_return(@profile_prep_item)
      @params = { }
    end
  
    it "should not create prep item with invalid params" do
      post 'create', :profile_prep_item => @params
      response.should_not be_success
    end
  
    it "should not update profile prep item with invalid params" do
      post 'update', :profile_prep_item => @params
    end
  
  end

end
