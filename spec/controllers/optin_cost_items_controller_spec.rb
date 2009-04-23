require File.dirname(__FILE__) + '/../spec_helper'

describe OptinCostItemsController do

  before do 
    session[:cas_sent_to_gateway] = true # make cas think it's already gone to the server to avoid redirect
    @viewer = mock_model(Viewer, :id => 1, :viewer_userID => "copter", :viewer_passWord => "9cdfb439c7876e703e307864c9167a15",
                        :viewer_isActive= => 1, :viewer_lastLogin= => Time.now, :save! =>'', :person =>'', :is_student? => false,
                        :is_eventgroup_coordinator? => true)
    Viewer.stub!(:find).and_return(@viewer)
    @event_group = mock_model(EventGroup, :id => 1, :title => '', :empty? => false, :logo => "a", :projects=>[], :prep_items =>[])
    EventGroup.stub!(:find).and_return(@event_group)
    @project = mock_model(Project, :id => 1, :find_all_by_hidden => [@project], :collect =>[])
    Project.stub!(:find).and_return(@project)
    @event_group.stub!(:projects).and_return(@project)
    session[:user_id] = @viewer.id
    session[:event_group_id]=1
    
    @cost_item = mock_model(CostItem, :id => 1, :description => '', :type => '', :amount => 1, :optional => true, :update_attributes =>self, :find => self,
                            :delete_if => '', :update_attributes => self)
    CostItem.stub!(:find).and_return(@cost_item)
    CostItem.stub!(:project).and_return(@project)
    @event_group.stub!(:cost_items).and_return([@cost_item])
    @params = {}
    
    @optin_cost_item = mock_model(OptinCostItem, :id => 1, :profile_id => 1, :cost_item_id => 1)
    OptinCostItem.stub!(:find).and_return(@optin_cost_item)
    @optin_cost_item.stub!(:profile).and_return(@profile)
    @optin_cost_item.stub!(:cost_item).and_return(@cost_item)
  end
  
  it "should update cost item" do
      post 'update', :cost_item => @params, :id => 1
      flash[:notice].should eql('CostItem was successfully updated.')
    end
    
    it "should destroy optin cost item" do
      @optin_cost_item.destroy
      response.should be_success
    end
  
end