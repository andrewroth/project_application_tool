require File.dirname(__FILE__) + '/../spec_helper'

describe ProfilePrepItemsController do

  before do 
    mock_viewer_as_event_group_coordinator
    mock_event_group
    mock_project
    mock_login
    
    @prep_item = mock_model(PrepItem, :id => 1, :title => '', :description => '', 
        :projects => mock('projects', :delete_all => []), :event_group_id= => 1, :errors => '', :applies_to => "year_item", 
        :individual => false, :deadline => '', :update_attributes => self, :destroy => self, :event_group= => nil, :event_group_id => nil)
    PrepItem.stub!(:find).and_return(@prep_item)
  end

  describe "valid profile prep item attributes" do
    
    before do
      mock_profile_prep_item
      mock_profile
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
      post 'index'
      response.should be_success
      response.should render_template('index')
    end
    
  end
  
  def mock_profile_prep_item
    @profile_prep_item = mock_model(ProfilePrepItem, :id => 1, :submitted => true, :received => true, :notes => '', :optional => true,
                                    :update_attributes => nil, :destroy => self, :find_or_create_by_prep_item_id => mock('prep_item', :save! => true),
                                    :save => true, :save! => true)
    ProfilePrepItem.stub!(:find).and_return(@profile_prep_item)
  end

  def mock_profile
    @profile = mock_model(Profile, :id => 1, :all_prep_items => [@prep_item], :profile_prep_items => @profile_prep_item, 
                          :all_profile_prep_items => [ @profile_prep_item ])
    Profile.stub!(:find).and_return(@profile)
  end

  describe "with invalid params" do
  
  before do
      mock_profile_prep_item
      mock_profile
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
