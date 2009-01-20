require File.dirname(__FILE__) + '/../spec_helper'

describe MainController do
  #integrate_views

  it "should display students on your campuses " do

    setup_eg; setup_form; setup_viewer; setup_project

    @campus = mock("campus", :persons => 
      [ mock('student1', :viewer => 
        mock('viewer10', :profiles =>
          [ mock('profiles', :appln => 
              mock('appln1', :preference1_id => 1, :form_id => 1),
              :class => Applying
          ) ]
        )
      ) ]
    )

    @viewer.stub!(
      :person => mock("person", { 
        :assignments => mock("assignments", 
          :find_all_by_campus_id => [ ] # parameter passed will be for regional_national_id
        ),
        :campuses => [ @campus ]
      })
    )

    @eg.stub!(:forms => mock("eg_forms", :find_by_hidden => @form),
      :projects => [ @project ]
    )

    Campus.stub!(:find).and_return([ @campus ])

    get :your_campuses

    assigns(:campus_stats).should_not be_nil
    cs = assigns(:campus_stats)[@campus] # cs = campus stats
    cs.should_not be_nil

    cs.students_cnt.should be(1)
    cs.student_profiles.length.should be(1)
    cs.accepted_cnt.should be(0)
    cs.applied_cnt.should be(1)
  end
end
