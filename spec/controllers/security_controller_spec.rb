require File.dirname(__FILE__) + '/../spec_helper'

describe SecurityController do
  #integrate_views
  
  before do 
    session[:cas_sent_to_gateway] = true # make cas think it's already gone to the server to avoid redirect

    mock_viewer
    @params = { :username => "copter", :password => "lol"}
  end
  
  it "should redirect to login when no user is given" do
    get :index # anything that requires a login will do
    response.should redirect_to('http://test.host/security/login')
  end
  
  it "should login a user with cim login" do
    post :login, @params
    assigns[:viewer].should == @viewer
  end
  
end
