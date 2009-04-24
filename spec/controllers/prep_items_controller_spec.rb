require File.dirname(__FILE__) + '/../spec_helper'

describe PrepItemsController do
  #integrate_views
    
   before do 
     stub_viewer_as_event_group_coordinator
     stub_event_group
     stub_project
     setup_login

     @prep_item = stub_model(PrepItem, :projects => [ @project ])
     stub_model_find(:prep_item)

     # handle checkbox_projects parts
     PrepItem.stub!(:find_by_id).with(@prep_item.id).and_return(@prep_item)
     PrepItem.stub!(:find_by_id).with(nil).and_return([])
     #@prep_item.stub!(:projects => mock('projects_assoc1', :delete_all => true, :replace => true, :first => @project))
     @prep_item.stub!(:projects => mock_ar_arr([ @project ]))
     @event_group.stub!(:projects => mock_ar_arr([ @project ], :find_all_by_hidden => [ @project ]))
     @event_group.stub!(:prep_items => [])

     @project.stub!(:prep_items => [])
  end
  
  describe "with valid params" do
  
    before do
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
      @prep_item.should_receive(:save).and_return(true)
      post 'update', :prep_item => @params, :id => @prep_item.id
      assigns[:prep_item].should_not be_new_record
      flash[:notice].should_not be_nil
      flash[:notice].should == 'PrepItem was successfully updated.'
    end
    
    it "should destroy prep item" do
      @prep_item.should_receive(:destroy).and_return(true)
      post 'destroy', :id => @prep_item.id
      response.should be_success
    end
    
    it "should set prep item eg to nil if projects exist" do
      @prep_item.event_group_id = @event_group.id
      @prep_item.stub!(:event_group => @event_group)
      @prep_item.should_receive(:update_attributes).and_return(true)
      post 'update', :id => @prep_item.id, :prep_item => { :project_ids => "#{@project.id}" }
      assigns[:prep_item].event_group_id.should be_nil
    end
    
    it "should render index" do
      post 'index'
      response.should be_success
      response.should render_template('index')
    end
    
  end
  
  describe "with invalid params" do
    before do
      # no project_id in params means event_group_id will be set
      @prep_item.stub!(:event_group => @event_group, :new_record? => true) 

      @params = {}
    end
    
    it "should not create a prep item on failed save" do
      PrepItem.should_receive(:new).with(@params).and_return(@prep_item)
      @prep_item.should_receive(:save).and_return(true)
      post 'create', :prep_item => @params
      assigns[:prep_item].should be_new_record
    end
    
    it "should render edit on failed prep item update" do
      @prep_item.should_receive(:update_attributes).and_return(true)
      post 'update', :id => @prep_item.id, :prep_item => @params
      response.should render_template('prep_items/update.js.rjs')
    end
    
  end
end
