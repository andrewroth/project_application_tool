require File.dirname(__FILE__) + '/../spec_helper'

describe MainController do
  it "should display students on your campuses " do

    setup_eg; setup_form; setup_viewer;

    session[:event_group_id] = 1

    @viewer.stub!(
      :person => mock("person", { 
        :assignments => mock("assignments", 
          :find_all_by_campus_id => [ ] # this is regional_national_id
        ),
        :campuses => [ mock("campus", :students => [ ] ) ]
      })
    )

    @eg.stub!(:forms =>
      mock("eg_forms", :find_by_hidden => @form)
    )

    @campus = mock("campus")
    Campus.stub!(:find_all_by_campus_id).and_return(@campus)

    get :your_campuses
  end
end
