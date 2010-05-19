require File.dirname(__FILE__) + '/../spec_helper'

describe ToolsController do

  before do 
    stub_viewer_as_event_group_coordinator
    stub_event_group
    stub_project
    stub_profile
    stub_appln
    setup_login
  end

  it "should render index" do
    get :index
    response.should be_success
  end
end 
