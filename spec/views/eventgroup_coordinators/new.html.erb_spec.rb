require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/eventgroup_coordinators/new.html.erb" do
  include EventgroupCoordinatorsHelper
  
  before(:each) do
    assigns[:eventgroup_coordinator] = stub_model(EventgroupCoordinator,
      :new_record? => true,
      :viewer_id => 1
    )
    assigns[:eg2] = stub_model(EventGroup, :id => 1)
  end

  it "should render new form" do
    render "/eventgroup_coordinators/new.html.erb"
    
    response.should have_tag("form")
  end
end


