require File.dirname(__FILE__) + '/../spec_helper'

describe CostItemsController do

  before do 
    session[:cas_sent_to_gateway] = true # make cas think it's already gone to the server to avoid redirect
    
    @event_group = mock_model(EventGroup, :id => 1, :title => '', :empty? => false, :logo => "a", :projects=>[], :prep_items =>[])
    EventGroup.stub!(:find).and_return(@event_group)
    @project = mock_model(Project, :id => 1, :find_all_by_hidden => [@project], :collect =>[])
    Project.stub!(:find).and_return(@project)
    @EventGroup.stub!(:projects).and_return(@project)
    
    session[:event_group_id]=1
    
    @cost_item = mock_model(CostItem, :id => 1, :description => '', :type => '', :amount => 1, :optional => true, :update_attributes =>self, :find => self,
                            :delete_if => '', :update_attributes => self)
    CostItem.stub!(:find).and_return(@cost_item)
    CostItem.stub!(:project).and_return(@project)
    @event_group.stub!(:cost_items).and_return(mock('cost item results', :find => [@cost_item]))
    @params = {}
  end

  describe "for eventgroup coordinator" do
    before do
      @viewer = mock_model(Viewer, :id => 1, :viewer_userID => "copter", :viewer_passWord => "9cdfb439c7876e703e307864c9167a15",
                          :viewer_isActive= => 1, :viewer_lastLogin= => Time.now, :save! =>'', :person =>'', :is_student? => false,
                          :is_eventgroup_coordinator? => true)
      Viewer.stub!(:find).and_return(@viewer)
      session[:user_id] = @viewer.id
    end
    
    it "should make a profile cost item" do
      post 'create', :cost_item => @params, :profile_id => '1'
      @cost_item.type.should eql(ProfileCostItem)
    end
    
    it "should not be a profile cost item if type is assigned" do
      assigns[:type] = 'YearCostItem'
      post 'create', :cost_item => @params
      @cost_item.type.should eql(YearCostItem)
    end
    
    it "should make yearcostitems for eg coordinators" do
      @event_group.should_receive(:is_eventgroup_coordinator).with(@viewer).and_return(true)
      post 'create', :cost_item => @params
      @cost_item.type.should eql(YearCostItem)
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
      @viewer = mock_model(Viewer, :id => 1, :viewer_userID => "copter", :viewer_passWord => "9cdfb439c7876e703e307864c9167a15",
                          :viewer_isActive= => 1, :viewer_lastLogin= => Time.now, :save! =>'', :person =>'', :is_student? => false,
                          :is_eventgroup_coordinator? => false, :acceptance_id => 1)
      Viewer.stub!(:find).and_return(@viewer)
      session[:user_id] = @viewer.id
    end
    
    it "should make a profile cost item" do
      post 'create', :cost_item => @params, :profile_id => '1'
      @cost_item.type.should eql(ProfileCostItem)
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