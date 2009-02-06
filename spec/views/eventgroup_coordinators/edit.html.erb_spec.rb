require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/eventgroup_coordinators/edit.html.erb" do
  include EventgroupCoordinatorsHelper
  
  before(:each) do
    assigns[:eventgroup_coordinator] = @eventgroup_coordinator = stub_model(EventgroupCoordinator,
      :new_record? => false,
      :viewer_id => 1
    )
  end

  it "should render edit form" do
    render "/eventgroup_coordinators/edit.html.erb"
    
    response.should have_tag("form[action=#{eventgroup_coordinator_path(@eventgroup_coordinator)}][method=post]") do
      with_tag('input#eventgroup_coordinator_viewer_id[name=?]', "eventgroup_coordinator[viewer_id]")
    end
  end
end


