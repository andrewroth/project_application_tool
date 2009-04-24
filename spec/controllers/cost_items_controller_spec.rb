require File.dirname(__FILE__) + '/../spec_helper'

describe CostItemsController do

  before do 
    mock_event_group
    mock_project

    @cost_item = mock_model(CostItem, :description => '', :type => '', :amount => 1, 
                            :optional => true, :update_attributes => true,
                            :delete_if => '', :update_attributes => self)
    CostItem.stub!(:find).and_return(@cost_item)
    CostItem.stub!(:project).and_return(@project)
    @event_group.stub!(:cost_items).and_return(mock('cost item results', :find => [@cost_item]))

    Profile.stub!(:find_all_by_project_id).and_return(mock_ar_arr([]))

    @params = {}
  end

  describe "for eventgroup coordinator" do
    before do
      mock_viewer_as_event_group_coordinator
      mock_profile
      mock_login
      @profile.stub!(:profile_cost_items => mock_ar_arr([]))
    end
    
    it "should make a profile cost item" do
      post 'create', :cost_item => @params, :profile_id => @profile.id
      assigns[:cost_item].class.should == ProfileCostItem
    end
    
    it "should not be a profile cost item if type is assigned" do
      assigns[:type] = 'YearCostItem'
      post 'create', :cost_item => @params
      assigns[:cost_item].class.should == YearCostItem
    end
    
    it "should make YearCostItems" do
      post 'create', :cost_item => @params
      assigns[:cost_item].class.should == YearCostItem
    end
    
    it "should create new cost item" do
      post 'create', :cost_item =>@params
      assigns[:cost_item].should_not be_new_record
      flash[:error].should be_nil
      flash[:notice].should eql('CostItem was successfully created.')
    end
        
    it "should update cost item" do
      post 'update', :cost_item => @params, :id => 1
      flash[:notice].should eql('CostItem was successfully updated.')
    end
    
    it "should destroy cost item" do
      CostItem.delete_all
      response.should be_success
    end
    
    it "should render index" do
      post 'index'
      response.should render_template('list')
    end
    
    it "should render list" do
       post 'list'
    end
       
    it "should be able to change type to yearcostitem" do
      @cost_item.should_receive(:[]=).with(:type, "YearCostItem")
      @cost_item.should_receive(:save!)
      post 'set_applies_to', :value => 'all'
    end
  
        
  end
  
  describe "for non eventgroup coordinator" do
    before do
      mock_viewer_as_staff
      mock_profile
      mock_login
    end
    
    it "should make a profile cost item" do
      ProfileCostItem.should_receive(:new).and_return(mock_model(ProfileCostItem, :save => true))
      post 'create', :cost_item => @params, :profile_id => '1'
      assigns[:cost_item].class.should == ProfileCostItem
    end
    
    it "should be able to change type to projectcostitem" do
      @cost_item.should_receive(:[]=).with(:type, "ProjectCostItem")
      post 'set_applies_to', :value => '1'
    end
    it "should render list" do
       post 'list'
    end
  end
    
end
