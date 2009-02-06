require File.dirname(__FILE__) + '/../spec_helper'

describe EventgroupCoordinatorsController do
  before do
    setup_eg; setup_viewer
  end

  def mock_eventgroup_coordinator(stubs={})
    @mock_eventgroup_coordinator ||= mock_model(EventgroupCoordinator, stubs)
  end
  
  describe "responding to GET index" do

    it "should redirect to list with the current event group id" do
      get :index, :id => @eg.id
      response.should redirect_to(:action => :list, :id => @eg.id)
    end

  end

  describe "responding to GET list" do

    it "should expose all eventgroup_coordinators as @eventgroup_coordinators" do
      @eg.should_receive(:eventgroup_coordinators).with().and_return([mock_eventgroup_coordinator])
      get :list, :id => @eg.id
      assigns[:eventgroup_coordinators].should == [mock_eventgroup_coordinator]
    end

  end

  describe "responding to GET new" do
  
    it "should expose a new eventgroup_coordinator as @eventgroup_coordinator" do
      EventgroupCoordinator.should_receive(:new).and_return(mock_eventgroup_coordinator)
      get :new, :id => @eg.id
      assigns[:eventgroup_coordinator].should equal(mock_eventgroup_coordinator)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created eventgroup_coordinator as @eventgroup_coordinator" do
        EventgroupCoordinator.should_receive(:find_or_create_by_event_group_id_and_viewer_id).with(1,1).and_return(mock_eventgroup_coordinator(:save => true))
        post :create, :eventgroup_coordinator => {:viewer_id => 1}
        assigns(:eventgroup_coordinator).should equal(mock_eventgroup_coordinator)
      end

      it "should redirect to the eventgroup_coordinators list" do
        EventgroupCoordinator.stub!(:find_or_create_by_event_group_id_and_viewer_id).with(1,1).and_return(mock_eventgroup_coordinator(:save => true))
        post :create, :eventgroup_coordinator => { :viewer_id => 1}
        response.should redirect_to(eventgroup_coordinators_url)
      end
      
    end
    
  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested eventgroup_coordinator" do
      EventgroupCoordinator.should_receive(:find).with("37").and_return(mock_eventgroup_coordinator)
      mock_eventgroup_coordinator.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the eventgroup_coordinators list" do
      EventgroupCoordinator.stub!(:find).and_return(mock_eventgroup_coordinator(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(eventgroup_coordinators_url)
    end

  end

end
