require File.dirname(__FILE__) + '/../spec_helper'

describe SecurityController do
  integrate_views
  
  before do 
    @viewer = mock_model(Viewer, :id => 1, :viewer_userID => "copter", :viewer_passWord => "9cdfb439c7876e703e307864c9167a15")
    Viewer.stub!(:find).and_return(@viewer)
    @params = { :username => "copter", :password => "lol"}
  end
  
  it "should redirect to login when no user is given" do
    get :index # anything that requires a login will do
    response.should redirect_to('http://test.host/security/login')
  end
  
  it "should login a user with cim login" do
    post :login, :viewer =>@params
    puts "r: #{response.body}"
    assigns[:viewer].should == @viewer
  end
  
end