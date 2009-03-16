require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/projects_coordinators/new.html.erb" do
  include ProjectsCoordinatorsHelper
  
  before(:each) do
    assigns[:projects_coordinator] = stub_model(ProjectsCoordinator,
      :new_record? => true,
      :viewer_id => 1
    )
  end

  it "should render new form" do
    render "/projects_coordinators/new.html.erb"
    
    response.should have_tag("form")
  end
end


