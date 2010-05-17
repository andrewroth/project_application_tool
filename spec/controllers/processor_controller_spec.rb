require File.dirname(__FILE__) + '/../spec_helper'

describe ProcessorController do

  before do 
    stub_viewer_as_event_group_coordinator
    stub_event_group
    stub_project
    stub_profile
    stub_appln
    setup_login
    
    #@cost_item = stub_model(CostItem)
    #stub_model_find(:cost_item)
    @appln.stub!(:references_text_list => "references_text_list")
  end
  
  it "should accept application" do
    # setup
    @profile.stub!(:project).and_return @project
    @profile.stub!(:appln).and_return @appln
    @profile.stub!(:save)
    @profile.stub!(:save!)
    @appln.stub!(:save!)
    # specs
    @profile.should_receive(:accept!)
    @profile.should_receive(:update_attributes).with(hash_including(
      :accepted_by_viewer_id => @viewer.id,
      :support_coach_id => "1"
    ))
    SpApplicationMailer.should_receive(:deliver_accepted).with(@profile, @viewer.email)
    # do it
    post 'accept', :support_coach_id => 1, :as_intern => 'false', :profile_id => @profile.id
  end

  it "should list actions with invalid pages listed" do
    page = mock_model(Page)
    questionnaire = mock_model(Questionnaire, :pages => [ page ])
    @pf = mock_model(Form, :questionnaire => questionnaire)
    @appln.stub!(:processor_form => @pf)
    forms = mock("forms")
    forms.stub!(:find_by_name).with("Processor Form").and_return(@pf)
    page.stub!(:validated?).with(@pf).and_return(false)
    @event_group.stub!(:forms).and_return(forms)
    get :actions, :profile_id => @profile.id
    assigns('invalid_pages').length.should > 0
  end

  it "should not lock evaluate when already locked" do
    @profile.stub!(:locked_by, mock_model(Viewer))
    @profile[:locked_by] = 2
    get :evaluate, :profile_id => @profile.id
    @profile[:locked_by].should == 2
    response.should be_redirect
  end

  it "should evaluate when already locked by yourself" do
    @profile.stub!(:locked_by => @viewer)
    get :evaluate, :profile_id => @profile.id
    response.should be_redirect
  end

  it "should evaluate when not locked by anyone" do
    @profile.stub!(:locked_by => nil)
    @profile.should_receive(:save!)
    get :evaluate, :profile_id => @profile.id
    @profile[:locked_by].should == @viewer.id
    response.should be_redirect
  end

  it "should release a profile" do
    @profile.should_receive(:locked_by=).with(nil)
    @profile.should_receive(:save!)
    get :release, :profile_id => @profile.id
    response.should be_redirect
  end

  it "should decline a profile" do
    @profile.should_receive(:manual_update).with(:type => 'Withdrawn', :status => 'declined',
                                                :viewer => @viewer)
    get :decline, :profile_id => @profile.id
    response.should be_redirect
  end

  it "should forward a profile" do
    @event_group.stub!(:projects => mock("projects", :find => @project))
    @profile.stub!(:project= => @project)
    @profile.stub!(:locked_by= => nil)
    @profile.should_receive(:save!)
    get :forward, :profile_id => @profile.id
    @profile.project.should == @project
    @profile.locked_by.should == nil
    response.should be_redirect
  end

  it "should deny someone without sufficient permissions" do
    @viewer.stub!(:is_eventgroup_coordinator? => false)
    @viewer.stub!(:is_processor? => false)
    @viewer.stub!(:is_staff? => true)
    get :forward, :profile_id => @profile.id
    flash[:notice].should_not be_nil
  end
end
