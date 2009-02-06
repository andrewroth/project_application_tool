require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventgroupCoordinatorsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "eventgroup_coordinators", :action => "index").should == "/eventgroup_coordinators"
    end
  
    it "should map #new" do
      route_for(:controller => "eventgroup_coordinators", :action => "new").should == "/eventgroup_coordinators/new"
    end
  
    it "should map #show" do
      route_for(:controller => "eventgroup_coordinators", :action => "show", :id => 1).should == "/eventgroup_coordinators/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "eventgroup_coordinators", :action => "edit", :id => 1).should == "/eventgroup_coordinators/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "eventgroup_coordinators", :action => "update", :id => 1).should == "/eventgroup_coordinators/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "eventgroup_coordinators", :action => "destroy", :id => 1).should == "/eventgroup_coordinators/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/eventgroup_coordinators").should == {:controller => "eventgroup_coordinators", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/eventgroup_coordinators/new").should == {:controller => "eventgroup_coordinators", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/eventgroup_coordinators").should == {:controller => "eventgroup_coordinators", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/eventgroup_coordinators/1").should == {:controller => "eventgroup_coordinators", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/eventgroup_coordinators/1/edit").should == {:controller => "eventgroup_coordinators", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/eventgroup_coordinators/1").should == {:controller => "eventgroup_coordinators", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/eventgroup_coordinators/1").should == {:controller => "eventgroup_coordinators", :action => "destroy", :id => "1"}
    end
  end
end
