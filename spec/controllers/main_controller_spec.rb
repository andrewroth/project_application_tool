require File.dirname(__FILE__) + '/../spec_helper'

class Spec::Mocks::Mock
  def mock_name() @name end
end

def mock_viewer(id) mock("viewer#{id}", :id => id) end
def mock_appln(o) 
  mock_name = "s#{o[:sid]}_app_#{o[:aid]}"
  mock(mock_name, 
         :viewer_id => o[:vid], 
         :form_id => @form.id,
         :profiles => o[:profiles]
  )
end
def mock_profile(o)
  mock("profile_#{o[:pid]}", :class => o[:c], :viewer_id => o[:vid])
end

describe MainController do
  #integrate_views

  it "should display students on your campuses " do

    setup_eg; setup_form; setup_viewer;

    session[:event_group_id] = 1

    students = [ 
       mock('student1', :viewers => [ mock_viewer(10) ] ),
       mock('student2', :viewers => [ mock_viewer(20), mock_viewer(21) ] ),
       mock('student3', :viewers => [ mock_viewer(30) ] ),
       mock('student4', :viewers => [ mock_viewer(40) ] ),
       mock('student5', :viewers => [ mock_viewer(50) ] ),
       mock('student6', :viewers => [ mock_viewer(60) ] ),
       mock('student7', :viewers => [ mock_viewer(70) ] )
    ]

    apps = [
       mock_appln(:sid => 1, :aid => 1, :profiles => [ mock_profile(:pid => 1, :c => Acceptance, :vid => 10) ] ),
       mock_appln(:sid => 2, :aid => 2, :profiles => [ mock_profile(:pid => 2, :c => Acceptance, :vid => 20),
                                                         mock_profile(:pid => 3, :c => Acceptance, :vid => 21) ] ), 
       mock_appln(:sid => 3, :aid => 3, :profiles => [ mock_profile(:pid => 4, :c => Applying, :vid => 30) ] ),
       mock_appln(:sid => 4, :aid => 3, :profiles => [ mock_profile(:pid => 5, :c => Applying, :vid => 40) ] ),
       mock_appln(:sid => 5, :aid => 3, :profiles => [ mock_profile(:pid => 6, :c => Withdrawn, :vid => 50) ] ),
    ]

    @campus = mock("campus", :students => students)

    @viewer.stub!(
      :person => mock("person", { 
        :assignments => mock("assignments", 
          :find_all_by_campus_id => [ ] # this is regional_national_id
        ),
        :campuses => [ @campus ]
      })
    )

    @eg.stub!(:forms =>
      mock("eg_forms", :find_by_hidden => @form)
    )

    Campus.stub!(:find_all_by_campus_id).and_return([ @campus ])
    Appln.stub!(:find_all_by_form_id).and_return(apps)

    get :your_campuses

    assigns(:campus_stats).should_not be_nil
    cs = assigns(:campus_stats)[@campus] # cs = campus stats
    cs.should_not be_nil

    cs.students_cnt.should be(7)
    cs.student_profiles.length.should be(6)
    cs.accepted_cnt.should be(3)
    cs.applied_cnt.should be(5)
  end
end
