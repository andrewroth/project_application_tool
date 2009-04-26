require File.dirname(__FILE__) + '/../spec_helper'

describe OptinCostItemsController do

  before do 
    stub_viewer_as_event_group_coordinator
    stub_event_group
    stub_project
    stub_profile
    setup_login
    
    @cost_item = stub_model(CostItem)
    stub_model_find(:cost_item)
  end
  
  it "should update cost item" do
    @cost_item.should_receive(:save).and_return(true)
    post 'update', :cost_item => {}, :id => @cost_item.id, :profile_id => @profile.id
    flash[:notice].should == 'CostItem was successfully updated.'
  end
    
  it "should destroy optin cost item" do
    @cost_item.should_receive(:destroy).and_return(true)

    # list is rendered
    @profile.stub!(:project => @project, :profile_cost_items => [])
    @project.stub!(:cost_items => [ @cost_item ])
    @event_group.stub!(:cost_items => [ ])

    post 'destroy', :id => @cost_item.id, :profile_id => @profile.id
    response.should be_success
  end
  
end
