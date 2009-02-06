require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/projects_coordinators/show.html.erb" do
  include ProjectsCoordinatorsHelper
  before(:each) do
    assigns[:projects_coordinator] = @projects_coordinator = stub_model(ProjectsCoordinator,
      :viewer_id => 1
    )
  end

  it "should render attributes in <p>" do
    render "/projects_coordinators/show.html.erb"
    response.should have_text(/1/)
  end
end

