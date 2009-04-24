require File.dirname(__FILE__) + '/../spec_helper'

describe OptinCostItemsController do

  before do 
    mock_viewer_as_event_group_coordinator
    mock_event_group
    mock_project
    mock_login
    mock_profile
    
    @cost_item = mock_model(CostItem, :description => '', :type => '', :amount => 1, :optional => true, :update_attributes => true,
                            :delete_if => '', :update_attributes => self)
    CostItem.stub!(:find).and_return(@cost_item)
    CostItem.stub!(:project).and_return(@project)
    @event_group.stub!(:cost_items).and_return([@cost_item])

    @params = {}
    
    @optin_cost_item = mock_model(OptinCostItem, :profile_id => 1, :cost_item_id => 1, :destroy => true)
    OptinCostItem.stub!(:find).and_return(@optin_cost_item)
    @optin_cost_item.stub!(:profile).and_return(@profile)
    @optin_cost_item.stub!(:cost_item).and_return(@cost_item)
  end
  
  it "should update cost item" do
      post 'update', :cost_item => @params, :id => @optin_cost_item.id
      flash[:notice].should eql('CostItem was successfully updated.')
    end
    
    it "should destroy optin cost item" do
      @optin_cost_item.destroy
      response.should be_success
    end
  
end
