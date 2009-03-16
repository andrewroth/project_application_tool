require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectsCoordinatorsController do
  before do
    setup_eg; setup_viewer
  end

  def mock_projects_coordinator(stubs={})
    @mock_projects_coordinator ||= mock_model(ProjectsCoordinator, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all projects_coordinators as @projects_coordinators" do
      ProjectsCoordinator.should_receive(:find).with(:all).and_return([mock_projects_coordinator])
      get :index
      assigns[:projects_coordinators].should == [mock_projects_coordinator]
    end

    describe "with mime type of xml" do
  
      it "should render all projects_coordinators as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        ProjectsCoordinator.should_receive(:find).with(:all).and_return(projects_coordinators = mock("Array of ProjectsCoordinators"))
        projects_coordinators.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested projects_coordinator as @projects_coordinator" do
      ProjectsCoordinator.should_receive(:find).with("37").and_return(mock_projects_coordinator)
      get :show, :id => "37"
      assigns[:projects_coordinator].should equal(mock_projects_coordinator)
    end
    
    describe "with mime type of xml" do

      it "should render the requested projects_coordinator as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        ProjectsCoordinator.should_receive(:find).with("37").and_return(mock_projects_coordinator)
        mock_projects_coordinator.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new projects_coordinator as @projects_coordinator" do
      ProjectsCoordinator.should_receive(:new).and_return(mock_projects_coordinator)
      get :new
      assigns[:projects_coordinator].should equal(mock_projects_coordinator)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created projects_coordinator as @projects_coordinator" do
        ProjectsCoordinator.should_receive(:find_or_create_by_viewer_id).with(1).and_return(mock_projects_coordinator(:save => true))
        @mock_projects_coordinator.should_receive(:update_attributes)
        post :create, :projects_coordinator => {:viewer_id => 1}
        assigns(:projects_coordinator).should equal(mock_projects_coordinator)
      end

      it "should redirect to the projects_coordinators list" do
        ProjectsCoordinator.stub!(:find_or_create_by_viewer_id).with(1).and_return(mock_projects_coordinator(:save => true))
        @mock_projects_coordinator.stub!(:update_attributes).and_return(true)
        post :create, :projects_coordinator => { :viewer_id => 1}
        response.should redirect_to(projects_coordinators_url)
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved projects_coordinator as @projects_coordinator" do
        ProjectsCoordinator.stub!(:find_or_create_by_viewer_id).with(nil).and_return(mock_projects_coordinator(:save => true))
        @mock_projects_coordinator.stub!(:update_attributes).with({}).and_return(true)
        post :create, :projects_coordinator => {}
        assigns(:projects_coordinator).should equal(mock_projects_coordinator)
      end

      it "should re-render the 'new' template" do
        ProjectsCoordinator.stub!(:new).and_return(mock_projects_coordinator(:save => false))
        @mock_projects_coordinator.stub!(:update_attributes).and_return(true)
        post :create, :projects_coordinator => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested projects_coordinator" do
        ProjectsCoordinator.should_receive(:find).with("37").and_return(mock_projects_coordinator)
        mock_projects_coordinator.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :projects_coordinator => {:these => 'params'}
      end

      it "should expose the requested projects_coordinator as @projects_coordinator" do
        ProjectsCoordinator.stub!(:find).and_return(mock_projects_coordinator(:update_attributes => true))
        put :update, :id => "1"
        assigns(:projects_coordinator).should equal(mock_projects_coordinator)
      end

      it "should redirect to the projects_coordinator" do
        ProjectsCoordinator.stub!(:find).and_return(mock_projects_coordinator(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(projects_coordinator_url(mock_projects_coordinator))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested projects_coordinator" do
        ProjectsCoordinator.should_receive(:find).with("37").and_return(mock_projects_coordinator)
        mock_projects_coordinator.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :projects_coordinator => {:these => 'params'}
      end

      it "should expose the projects_coordinator as @projects_coordinator" do
        ProjectsCoordinator.stub!(:find).and_return(mock_projects_coordinator(:update_attributes => false))
        put :update, :id => "1"
        assigns(:projects_coordinator).should equal(mock_projects_coordinator)
      end

      it "should re-render the 'edit' template" do
        ProjectsCoordinator.stub!(:find).and_return(mock_projects_coordinator(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested projects_coordinator" do
      ProjectsCoordinator.should_receive(:find).with("37").and_return(mock_projects_coordinator)
      mock_projects_coordinator.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the projects_coordinators list" do
      ProjectsCoordinator.stub!(:find).and_return(mock_projects_coordinator(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(projects_coordinators_url)
    end

  end

end
