require File.dirname(__FILE__) + '/../spec_helper'

describe SecurityController do
  # since I can't use a pure ApplicationController spec, these
  # specs are for ApplicationController
  it "should at least not crash when when rescues_path is called" do
    get :test_rescues_path
  end

  it "should set server_url for development/test" do
    get :test_rescues_path # anything will do
    $server_url.should == 'http://dev.spt.campusforchrist.org'
  end

  it "should set no_cache on xhr" do
    xhr :get, :test_rescues_path # anything will do
    response.headers['Cache-Control'].inspect['max-age=0'].should_not be_nil
  end

=begin
Can't get it to set the env

  it "should set server_url for production" do
    ENV["RAILS_ENV"] = 'development' # doesn't work???
    get :test_rescues_path # anything will do
    $server_url.should == 'https://spt.campusforchrist.org'
  end
=end

  it "should print pdf when requested" do # or at least not crash if the htmldoc isn't installed
    get :test_rescues_path, :print => 'pdf' # anything will do
  end

  it "should redirect to login when no user is given" do
    get :do_link_gcx # anything that requires a login will do
    response.should redirect_to('http://test.host/security/login')
  end

=begin
  it "should set @appln given an appln_id" do
    setup_eg; setup_form; setup_viewer; setup_project

    @appln = mock('appln')
    Appln.should_receive(:find).with(1).and_return(@appln)

    post :test_rescues_path, :appln_id => 1
    puts 'response: ' +response.body
  end

  it "should restrict students who aren't set as staff on a project" do
    setup_eg; setup_form; setup_viewer(:student => true); setup_project

    post :test_rescues_path # anything that has restrict_students before_filter enabled will do
    response.should redirect_to('http://test.hosttest.host/your_apps')
  end

  it "should allow students assigned as staff" do
    setup_eg; setup_form; setup_viewer(:student => true); setup_project

    @user.stub!(:is_any_project_staff => true)
    post :test_rescues_path # anything that has restrict_students before_filter enabled will do
    response.should_not redirect_to('http://test.hosttest.host/your_apps')
  end

  it "should force you to scope an event group" do
    setup_form; setup_viewer(:student => true); setup_project
    setup_appln_profile

    post :test_rescues_path # anything will do
    response.should redirect_to(scope_event_groups_url)
  end
=end

end
