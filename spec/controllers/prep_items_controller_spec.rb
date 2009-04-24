require File.dirname(__FILE__) + '/../spec_helper'

describe PrepItemsController do
  #integrate_views
    
   before do 
     mock_viewer_as_event_group_coordinator
     mock_event_group
     mock_project
     mock_login
  end
  
  describe "with valid params" do
  
    before do
      @prep_item = mock_model(PrepItem, :id => 1, :title => '', :description => '', 
        :projects => mock('projects', :delete_all => []), :event_group_id= => 1, :errors => '', :applies_to => "year_item", 
        :individual => false, :deadline => '', :update_attributes => self, :destroy => self, :event_group= => nil, :event_group_id => nil, :deadline_optional= => true)
      PrepItem.stub!(:find).and_return(@prep_item)
      @params = {}
    end
    it "should create a prep item upon create" do
      PrepItem.should_receive(:new).with(@params).and_return(@prep_item)
      @prep_item.should_receive(:save).and_return(true)
      post 'create', :prep_item => @params
      assigns[:prep_item].should_not be_new_record
      flash[:error].should be_nil
      flash[:notice].should == 'PrepItem was successfully created.'
    end
    
    it "should update prep item" do
      post 'update', :prep_item => @params, :id => 1
      assigns[:prep_item].should_not be_new_record
      flash[:notice].should_not be_nil
    end
    
    it "should have a success notice when prep item is updated" do
      post 'update', :prep_item => @params, :id => 1
      flash[:notice].should == 'PrepItem was successfully updated.'
    end
    
    it "should destroy prep item" do
      post 'destroy', :id => 1
      response.should be_success
    end
    
    it "should set prep item eg to nil if projects exist" do
      post 'update', :prep_item => { :project_ids => [1, 2]  }
      assigns[:prep_item].event_group_id.should be_nil
    end
    
    it "shoud pass prep item params" do
      post 'create', :prep_item => { :title => 'item', :description => 'not blank'}
      assigns[:prep_item].title.should == 'item'
      assigns[:prep_item].description.should == 'not blank'
    end

    it "should render index" do
      post 'index'
      response.should be_success
      response.should render_template('index')
    end
    
  end
  
  describe "with invalid params" do
    before do
      @prep_item = mock_model(PrepItem, :id => 1, :title => '', :description => '', 
                              :projects => mock('projects', :delete_all => []), :event_group_id= => 1, :errors => '', :applies_to => "year_item", 
                              :individual => false, :deadline => '', :update_attributes => nil, :destroy => self, :event_group= => nil, 
                              :event_group_id => nil, :deadline_optional= => false)
      PrepItem.stub!(:find).and_return(@prep_item)
      @params = {}
    end
    
    it "should not create a prep item on failed save" do
      post 'create', :prep_item => @params
      assigns[:prep_item].should be_new_record
    end
    
    it "should render edit on failed prep item update" do
      post 'update', :prep_item => @params
      response.should render_template('prep_items/update.js.rjs')
    end
    
  end
end
