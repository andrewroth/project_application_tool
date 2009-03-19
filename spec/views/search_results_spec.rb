require File.dirname(__FILE__) + '/../spec_helper'

describe "/main/_viewer_specifics" do

  def setup_all(o)
    @person = mock('person', :campus_shortDesc => 'CAMPUS')
    @viewer = mock('Viewer',
        :name => 'Viewer',
        :viewer_userID => 'viewer.login',
        :person => @person
    )
    @viewer = mock('user', :set_project => nil,
              :fullview? => o[:fullview],
              :can_modify_profile_in_project => false,
              :is_projects_coordinator? => o[:fullview],
              :is_eventgroup_coordinator? => o[:fullview],
              :is_project_administrator? => false,
              :is_processor? => false
    )

    assigns[:viewer] = @viewer
    assigns[:user] = @viewer

    @project = mock('project', :title => 'project', :id => 1)
    @appln = mock('appln', :id => 1, :form => mock('form2', 
                    :id => 2, :questionnaire => mock('q', :references => [ ])),
                    :viewer => @viewer, :submitted_at => 5.days.ago, 
                    :completed_at => nil, :reference_instances => [])
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
                 :status => 'started',
                 :cached_costing_total => 1000,
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

  it "should show a processor pile result of a past event group" do
    setup_all :fullview => true;
    assigns[:eg] = mock('eg', :forms => mock('forms', :find_all_by_hidden => [ ]))

    @profile.stub!(:class => Applying)
    @form.stub!(:event_group_id => 2)
    @appln.stub!(:status => @profile.status)
    @appln.stub!(:as_intern? => false)

    render :partial => "/main/viewer_specifics"

    response.should include_text('view entire')
  end

end
