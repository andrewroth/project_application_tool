require File.dirname(__FILE__) + '/../spec_helper'

describe PrepItemsController do
  #integrate_views
    
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
  end
  
  describe "with valid params" do
  
    before do
      @prep_item = mock_model(PrepItem, :id => 1, :title => '', :description => '', 
        :projects => mock('projects', :delete_all => []), :event_group_id= => 1, :errors => '', :applies_to => "year_item", 
        :individual => false, :deadline => '', :update_attributes => self, :destroy => self, :event_group= => nil, :event_group_id => nil)
      PrepItem.stub!(:find).and_return(@prep_item)
      @params = {}
    end
    it "should create a prep item upon save" do
      PrepItem.should_receive(:new).with(@params).and_return(@prep_item)
      @prep_item.should_receive(:save)
      post 'create', :prep_item =>@params
      assigns[:prep_item].should_not be_new_record
      flash[:error].should be_nil
    end
    
    it "should have a success notice when prep item is created" do
    PrepItem.should_receive(:new).with(@params).and_return(@prep_item)
      @prep_item.should_receive(:save)
      post 'create', :prep_item =>@params
      flash[:notice].should eql('PrepItem was successfully created.')
    end
    
    it "should update prep item" do
      post 'update', :prep_item=>@params, :id => 1
      assigns[:prep_item].should_not be_new_record
      flash[:notice].should_not be_nil
    end
    
    it "should have a success notice when prep item is updated" do
      post 'update', :prep_item =>@params, :id => 1
      flash[:notice].should eql('PrepItem was successfully updated.')
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
        :individual => false, :deadline => '', :update_attributes => nil, :destroy => self, :event_group= => nil, :event_group_id => nil)
      PrepItem.stub!(:find).and_return(@prep_item)
      @params = {}
    end
    
    it "should not create a prep item on failed save" do
      post 'create', :prep_item =>@params
      assigns[:prep_item].should be_new_record
    end
    
    it "should render edit on failed prep item update" do
      post 'update', :prep_item => @params
      response.should render_template('prep_items/update.js.rjs')
    end
    
  end
end