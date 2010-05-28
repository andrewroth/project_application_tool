require File.dirname(__FILE__) + '/../spec_helper'

describe AcceptanceController do

  before do 
    stub_event_group
    stub_project
    stub_profile
  end

  describe "for eventgroup coordinator" do

    before do
      stub_viewer_as_event_group_coordinator
      stub_profile
      setup_login
    end

    describe "update_intern_status should update status" do

      it "html request" do
        @profile.should_receive(:save!)
        post 'update_intern_status', :profile_id => @profile.id
        @profile.as_intern.should be_true
      end

      it "ajax request" do
        @profile.should_receive(:save!)
        xhr :post, 'update_intern_status', :profile_id => @profile.id
        @profile.as_intern.should be_true
      end

    end

    describe "update_support_coach should update support coach" do

      it "html request none" do
        @profile.should_receive(:save!)
        post 'update_support_coach', :profile_id => @profile.id, :support_coach_id => Acceptance.support_coach_none
        @profile.support_coach_id.should == nil
      end

      it "ajax request with support coach id" do
        @profile.should_receive(:save!)
        xhr :post, 'update_support_coach', :profile_id => @profile.id, :support_coach_id => @viewer.id
        @profile.support_coach_id.should == @viewer.id
      end

    end
  end

  describe "for general staff" do
    before do
      stub_viewer_as_staff
      stub_profile
      setup_login
    end

    it "should disallow udpate_support_coach" do
      @profile.should_not_receive(:save!)
      post 'update_support_coach', :profile_id => @profile.id, :support_coach_id => Acceptance.support_coach_none
    end
  end
end
