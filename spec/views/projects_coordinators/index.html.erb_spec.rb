require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/projects_coordinators/index.html.erb" do
  include ProjectsCoordinatorsHelper
  
  before(:each) do
    assigns[:projects_coordinators] = [
      stub_model(ProjectsCoordinator,
        :viewer_id => 1
      ),
      stub_model(ProjectsCoordinator,
        :viewer_id => 1
      )
    ]
  end

  it "should render list of projects_coordinators" do
    render "/projects_coordinators/index.html.erb"
  end
end

