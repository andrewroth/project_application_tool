require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/projects_coordinators/edit.html.erb" do
  include ProjectsCoordinatorsHelper
  
  before(:each) do
    assigns[:projects_coordinator] = @projects_coordinator = stub_model(ProjectsCoordinator,
      :new_record? => false,
      :viewer_id => 1
    )
  end

  it "should render edit form" do
    render "/projects_coordinators/edit.html.erb"
    
    response.should have_tag("form[action=#{projects_coordinator_path(@projects_coordinator)}][method=post]") do
      with_tag('input#projects_coordinator_viewer_id[name=?]', "projects_coordinator[viewer_id]")
    end
  end
end


