require File.dirname(__FILE__) + '/../spec_helper'

describe YourAppsController do

  it "should create a new application and profile on start" do
    setup_eg; setup_form; setup_viewer; setup_project;

    @viewer.stub!(:applns => mock('applns', :find_by_form_id => nil))

    @new_appln = mock('new_appln')
    @new_profile = mock('new_profile', :viewer_id= => @viewer.id, :id => 1)
    @new_appln.should_receive(:profile).and_return(@new_profile)
    @new_appln.should_receive(:preference1_id=).with(1)
    @new_appln.should_receive(:preference2_id=).with(1)
    @new_profile.should_receive(:project_id=).with(1)

    @new_profile.should_receive(:save!).at_least(1)
    @new_appln.should_receive(:save!)

    Appln.should_receive(:create).and_return(@new_appln)

    get :start, :form_id => @form.id
  end

  it "should not create a new application if one exists" do
    setup_eg; setup_form; setup_viewer; setup_project;

    @appln = mock('appln')
    @profile = mock('profile', :viewer_id= => @viewer.id, :id => 1)

    @viewer.stub!(:applns => mock('applns', :find_by_form_id => @appln))

    @appln.should_receive(:profile).and_return(@profile)

    Appln.should_not_receive(:create)

    get :start, :form_id => @form.id
    response.should redirect_to('http://test.host/appln?profile_id=1')
  end

  it "should be able to continue an existing application" do
    setup_eg; setup_form; setup_viewer; setup_project;

    @appln = mock('appln')
    @profile = mock('profile', :viewer_id= => @viewer.id, :id => 1)
    @viewer.stub!(:applns => mock('applns', :find_by_form_id => @appln))

    Profile.should_receive(:find).and_return @profile

    get :continue, :profile_id => @profile.id
    response.should redirect_to('http://test.host/appln?profile_id=1')
  end

  def profile(name, o)
    mock(name, o.merge(:appln => mock("#{name}_appln", :form => 
       mock("#{name}_form", :id => o[:form_id] || @form.id ))))
  end

  it "should list the right started, unsubmitted, completed, withdrawn, acceptances lists" do
    setup_viewer; setup_eg; setup_form; setup_project;

    Form.stub!(:find => @form)

    @viewer.should_receive(:profiles).and_return(mock('profiles', :find => [
      profile('started', :class => Applying, :status => 'started'),
      profile('unsubmitted', :class => Applying, :status => 'unsubmitted'),
      profile('submitted', :class => Applying, :status => 'submitted'),
      profile('completed', :class => Applying, :status => 'completed'),
      profile('withdrawn', :class => Withdrawn, :status => 'self_withdrawn'),
      profile('accepted', :class => Acceptance, :status => 'accepted'),
    ]))

    get :list

    assigns('started').length.should == 1
    assigns('unsubmitted').length.should == 1
    assigns('submitted').length.should == 1
    assigns('completed').length.should == 1
    assigns('withdrawn').length.should == 1
    assigns('acceptances').length.should == 1
  end

  it "should have the right list of forms that can be started" do
    setup_viewer; setup_eg; setup_form; setup_project;

    @forms.should_receive(:find_all_by_hidden).with(false).and_return([
               @f1 = mock('f1', :id => 1),
               @f2 = mock('f2', :id => 2),
               @f3 = mock('f3', :id => 3),
             ])

    @viewer.should_receive(:profiles).and_return(mock('profiles', :find => [
      profile('started', :class => Applying, :status => 'started', :form_id => 1),
      profile('accepted', :class => Acceptance, :status => 'accepted', :form_id => 3),
    ]))

    Form.should_receive(:find).with([ 2 ]).and_return(@f2)

    get :list
  end

  it "should redirect index to list" do
    setup_viewer; setup_eg; setup_form
    
    get :index
    response.should redirect_to('http://test.host/your_apps/list')
  end

  it "should redirect view always editable" do
    setup_viewer; setup_eg; setup_form; setup_profile
    
    get :view_always_editable, :profile_id => 1
    response.should redirect_to('http://test.host/appln/view_always_editable?profile_id=1')
  end

  it "should redirect acceptance to profiles" do
    setup_viewer; setup_eg; setup_form; setup_profile
    
    get :acceptance, :profile_id => 1
    response.should redirect_to('http://test.host/profiles/view/1')
  end
end
