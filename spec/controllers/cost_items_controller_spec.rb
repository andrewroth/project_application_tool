require File.dirname(__FILE__) + '/../spec_helper'

describe CostItemsController do

  before do 
    stub_event_group
    stub_project
  end

  describe "for eventgroup coordinator" do

    before do
      stub_viewer_as_event_group_coordinator
      stub_profile
      setup_login
      @profile.stub!(:profile_cost_items => mock_ar_arr([]))
    end
    
    describe "create" do

      before do
      end

      it "should be a profile cost item by default" do
        @profile_cost_item = stub_model(ProfileCostItem, :profile => @profile)
        ProfileCostItem.should_receive(:new).and_return(@profile_cost_item)
        @profile_cost_item.should_receive(:save).and_return(true)

        post 'create', :cost_item => {}, :profile_id => @profile.id
        assigns[:cost_item].class.should == ProfileCostItem
        assigns[:cost_item].should_not be_new_record
        flash[:error].should be_nil
        flash[:notice].should eql('CostItem was successfully created.')
      end

      it "should make YearCostItems if no profile_id given" do
        @year_cost_item = stub_model(YearCostItem, :event_group => @event_group)
        YearCostItem.should_receive(:new).and_return(@year_cost_item)
        @year_cost_item.should_receive(:save).and_return(true)

        post 'create'
        assigns[:cost_item].class.should == YearCostItem
      end

      it "should make ProjectCostItems" do
        @project_cost_item = stub_model(ProjectCostItem, :project => @project)
        Project.stub!(:find_all_by_project_id).with([@project.id]).and_return([@project])
        ProjectCostItem.should_receive(:new).and_return(@project_cost_item)
        @project_cost_item.should_receive(:save).and_return(true)

        post 'create', :cost_item => { :type => 'ProjectCostItem' }
        assigns[:cost_item].class.should == ProjectCostItem
      end

    end

    describe "" do

      before do
        @cost_item = stub_model(CostItem)
        CostItem.should_receive(:find).with(@cost_item.id.to_s).and_return(@cost_item)
      end

      it "should update cost item" do
        @cost_item.should_receive(:amount=).with(2)
        @cost_item.should_receive(:save).and_return(true)
        post 'update', :id => @cost_item.id, :cost_item => { :amount => 2 }
        flash[:notice].should == 'CostItem was successfully updated.'
      end

      it "should destroy cost item" do
        @cost_item.should_receive(:destroy)
        @event_group.stub!(:cost_items).and_return([@cost_item])
        post 'destroy', :id => @cost_item.id
        response.should be_success
      end

      it "should be able to change type to yearCostItem" do
        @cost_item.should_receive(:[]=).with(:type, "YearCostItem")
        @cost_item.should_receive(:save!)
        @cost_item.stub!(:update_costing_total_cache)
        post 'set_applies_to', :id => @cost_item.id, :value => 'all'
      end

    end
    
    it "should render index" do
      @event_group.stub!(:cost_items).and_return([@cost_item])
      post 'index'
      response.should render_template('list')
    end
    
    it "should render list" do
       @event_group.stub!(:cost_items).and_return([@cost_item])
       get 'list'
    end
       
  end
  
  describe "for non eventgroup coordinator" do
    before do
      stub_viewer_as_staff
      stub_profile
      setup_login
    end
    
    it "should make a profile cost item" do
      @profile_cost_item = stub_model(ProfileCostItem, :save => true)
      ProfileCostItem.should_receive(:new).and_return(@profile_cost_item)
      post 'create', :cost_item => @params, :profile_id => '1'
      assigns[:cost_item].class.should == ProfileCostItem
    end
    
    it "should not be able to change type to ProjectCostItem" do
      @cost_item = stub_model(CostItem)
      CostItem.should_receive(:find).with(@cost_item.id.to_s).and_return(@cost_item)
      @cost_item.should_not_receive(:[]=).with(:type, "ProjectCostItem")
      post 'set_applies_to', :id => @cost_item.id, :value => 1
    end

    it "should render list" do
       @event_group.stub!(:cost_items).and_return([@cost_item])
       get 'list'
    end
  end
end
