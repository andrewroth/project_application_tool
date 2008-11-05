require File.dirname(__FILE__) + '/../spec_helper'

describe AssignmentsController do
  def setup_all
    setup_eg; setup_form; setup_viewer(:student => true); setup_project

    @person = mock('person', :id => 1)
    @viewer.stub!(:person => @person, :current_projects_with_any_role => [])
  end

  it "should allow students to do new" do
    setup_all

    get :new

    response.should_not be_redirect
  end

  it "should allow students to update" do
    setup_all

    post :update, {"commit"=>"Save", "assignment"=>{"new"=>{"1"=>{"campus_id"=>"1", "assignmentstatus_id"=>"0"}, "2"=>{"campus_id"=>"1", "assignmentstatus_id"=>"3"}}, "update"=>{"1708"=>{"campus_id"=>"54", "assignmentstatus_id"=>"1"}}}, "action"=>"update", "appln_person"=>{"grad_date(1i)"=>"2008", "grad_date(2i)"=>"11", "grad_date(3i)"=>"5", "year_in_school_id"=>"1"}, "controller"=>"assignments"}

    response.should redirect_to('http://test.host/profiles/campus_info')
  end
end
