require File.dirname(__FILE__) + '/../spec_helper'

describe ApplnController do

  def setup_appln
    @appln = mock("appln", :form => @form, :viewer => @viewer, :id => 1)
    @profile = mock("profile", :id => 1, 
         :appln => @appln, 
         :viewer => @viewer, 
         :project => @project, 
         :id => 1)
    @appln.stub!(:profile => @profile)

    Appln.stub!(:find).and_return(@appln)
  end

  it "should require appln_id" do
    setup_eg; setup_form; setup_viewer; setup_project

    get :view_always_editable, :profile_id => 1
    response.body.should == "Couldn't find application id "
  end

  it "should allow view always editable" do
    setup_eg; setup_form; setup_viewer; setup_project; setup_appln;

    @appln = mock("appln", :form => @form, :viewer => @viewer, :id => 1)
    @profile = mock("profile", :id => 1, 
         :appln => @appln, 
         :viewer => @viewer, 
         :project => @project, 
         :id => 1)
    @appln.stub!(:profile => @profile)

    Appln.stub!(:find).and_return(@appln)

    get :view_always_editable, :appln_id => 1
    assigns('pass_params')
  end

  it "should not crash on preview" do
    setup_eg; setup_form; setup_viewer; setup_project; setup_appln

    get :preview, :appln_id => 1
    assigns('page_title')
  end

  it "should not crash on withdrawl_reason" do
  end
end
