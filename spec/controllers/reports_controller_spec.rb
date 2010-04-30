require File.dirname(__FILE__) + '/../spec_helper'

describe ReportsController do

  before do 
    stub_viewer_as_event_group_coordinator
    stub_event_group
    stub_form
    stub_project
    stub_profile
    stub_appln
    setup_login
  end

  it "should report all accepted people when calling project_stats" do
    Applying.stub!(:find_all_by_status_and_project_id).and_return([ @profile ])
    Applying.stub!(:find_all_by_project_id_and_status).and_return([])
    Applying.stub!(:find_all_by_project_id_and_status).and_return([])
    Acceptance.stub!(:find_all_by_project_id_and_as_intern).and_return([])
    Withdrawn.stub!(:find_all_by_status_and_project_id).and_return([])
    get 'project_stats', :project_id => @project.id
    puts @response.body
  end
end
