require File.dirname(__FILE__) + '/../spec_helper'

describe "/main/_viewer_specifics" do

  def setup_all(o)
    @person = mock('person', :campus_shortDesc => 'CAMPUS')
    @viewer = mock('Viewer',
        :name => 'Viewer',
        :viewer_userID => 'viewer.login',
        :person => @person
    )
    @user = mock('user', :set_project => nil,
              :fullview? => o[:fullview],
              :can_modify_profile_in_project => false,
              :is_projects_coordinator? => o[:fullview],
              :is_project_administrator? => false,
              :is_processor? => false
    )

    assigns[:viewer] = @viewer
    assigns[:user] = @user

    @project = mock('project', :title => 'project', :id => 1)
    @appln = mock('appln', :id => 1)
    @profile = mock('profile',
                 :class => Acceptance,
                 :project => @project,
                 :appln => @appln,
                 :viewer => @viewer,
                 :person => @person,
                 :accepted_at => 10.days.ago,
                 :support_claimed => 1000,
                 :support_claimed_updated_at => 25.minutes.ago,
                 :donations_total => 1000,
                 :as_intern? => false,
                 :motivation_code => '123ABC',
                 :funding_target => 123,
                 :support_coach_str => 'john doe',
                 :id => 1
    )

    assigns[:profiles_by_eg] = {
        mock('eg', 
                 :to_s_with_ministry_and_eg_path => 'eg',
                 :empty? => false
        ) => [ @profile ]
    }
  end

  it "should have full view on search with a pc" do
    setup_all :fullview => true

    render :partial => "/main/viewer_specifics"

    response.should include_text('view entire')
  end

  it "should not have full view on search for someone without that access" do
    setup_all :fullview => false

    render :partial => "/main/viewer_specifics"

    response.should_not include_text('view entire')
  end

end
