require File.dirname(__FILE__) + '/../spec_helper'

describe PrepItemsController do
  integrate_views
  fixtures :prep_items
  
  
   before do 
    session[:cas_sent_to_gateway] = true # make cas think it's already gone to the server to avoid redirect
    @viewer = mock_model(Viewer, :id => 1, :viewer_userID => "copter", :viewer_passWord => "9cdfb439c7876e703e307864c9167a15",
                        :viewer_isActive= => 1, :viewer_lastLogin= => Time.now, :save! =>'', :person =>'', :is_student? => false)
    Viewer.stub!(:find).and_return(@viewer)
    @event_group = mock_model(EventGroup, :id => 1, :empty? => false, :logo => "a", :projects=>'')
    EventGroup.stub!(:find).and_return(@event_group)
    @project = mock_model(Project, :id => 1, :hidden => false)
    Project.stub!(:find).and_return(@project)
    session[:user_id] = @viewer.id
    session[:event_group_id]=1
  end
  
  it "should redirect to index on successful save" do
    PrepItem.any_instance.stubs(:valid?).returns(true)
    post 'create'
    response.should redirect_to(prep_items_path)  
    assigns[:prep_item].should_not be_new_record
    flash[:notice].should be_nil
  
  end
  
  it "should render new template on failed save" do
    PrepItem.any_instance.stubs(:valid?).returns(false)
    post 'create'
    assigns[:prep_item].should be_new_record
    response.should render_template('new')
  end
  
  it "shoud pass prep item params" do
    post 'create', :prep_item => { :title => 'item', :description => 'not blank'}
    assigns[:prep_item].title.should == 'item'
    assigns[:prep_item].description.should == 'not_blank'
  end
  
end