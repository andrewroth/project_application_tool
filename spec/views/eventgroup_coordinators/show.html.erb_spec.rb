require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/eventgroup_coordinators/show.html.erb" do
  include EventgroupCoordinatorsHelper
  before(:each) do
    assigns[:eventgroup_coordinator] = @eventgroup_coordinator = stub_model(EventgroupCoordinator,
      :viewer_id => 1
    )
  end

  it "should render attributes in <p>" do
    render "/eventgroup_coordinators/show.html.erb"
    response.should have_text(/1/)
  end
end

