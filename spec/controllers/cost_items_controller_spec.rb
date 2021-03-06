require File.dirname(__FILE__) + '/../spec_helper'

describe CostItemsController do

  before do 
    stub_event_group
    stub_project
    stub_profile
  end

  describe "for eventgroup coordinator" do

    before do
      stub_viewer_as_event_group_coordinator
      stub_profile
      setup_login
      @profile.stub!(:profile_cost_items => [])
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
        stub_model_find(:cost_item)
      end

      it "should update cost item" do
        @cost_item.should_receive(:amount=).with("2")
        @cost_item.should_receive(:save).and_return(true)
        post 'set_cost_item_amount', :id => @cost_item.id, :value => 2
        response.should be_success
      end

      it "should destroy cost item" do
        @cost_item.should_receive(:destroy)
        @event_group.stub!(:cost_items).and_return([@cost_item])
        post 'destroy', :id => @cost_item.id
        response.should be_success
      end

      it "should be able to change type to YearCostItem" do
        @cost_item.should_receive(:[]=).with(:type, "YearCostItem")
        @cost_item.should_receive(:save!)
        @cost_item.stub!(:update_costing_total_cache)
        @event_group.should_receive(:cost_items).and_return([])
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
      post 'create', :cost_item => @params, :profile_id => @profile.id
      assigns[:cost_item].class.should == ProfileCostItem
    end

    it "should not be able to change type to ProjectCostItem" do
      @cost_item = stub_model(CostItem)
      stub_model_find(:cost_item)
      @cost_item.should_not_receive(:[]=).with(:type, "ProjectCostItem")
      post 'set_applies_to', :id => @cost_item.id, :value => 1
    end
    
    it "should not be able to change type to YearCostItem" do
      @cost_item = stub_model(CostItem)
      stub_model_find(:cost_item)
      @cost_item.should_not_receive(:[]=).with(:type, "YearCostItem")
      post 'set_applies_to', :id => @cost_item.id, :value => 'all'
    end

    end

    it "should render list" do
      @event_group.stub!(:cost_items).and_return([@cost_item])
      get 'list'
    end
    
    describe "with invaild params" do
      before do
        stub_viewer_as_staff
        stub_profile
        setup_login
        @cost_item = stub_model(YearCostItem, :update_attributes => nil)
        stub_model_find(:cost_item)
        stub_model_find(:cost_item, CostItem)
      end
      
      it "should not create (with no access)" do
        @project_cost_item.should be_nil
        post 'create', :cost_item => { :type => 'ProjectCostItem' }
        assigns[:cost_item].class.should_not == ProjectCostItem
      end
  
      it "should not update" do
        post 'set_cost_item_amount', :id => @cost_item.id, :value => 2
        flash[:notice].should_not == 'CostItem was successfully updated.'
      end
      
    end
end
