require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../../config/boot'

describe EventGroupsController do
  it "should hide hidden event groups" do
    setup_eg; setup_viewer;

    EventGroup.should_receive(:find_all_by_parent_id_and_hidden).and_return([ @eg ])
    @eg.should_receive(:filter_hidden=).with(true)
    @eg.stub!(:expanded= => nil, :children => [])

    get :scope
    assigns('nodes').should_not be_nil
    assigns('show_hidden').should be_false
  end

  it "should not allow students to see hidden event groups" do
    setup_eg; setup_viewer(:student => true);

    EventGroup.should_receive(:find_all_by_parent_id_and_hidden).and_return([ @eg ])
    @eg.should_receive(:filter_hidden=).with(true)
    @eg.stub!(:expanded= => nil, :children => [])
    @viewer.stub!(:current_projects_with_any_role => [])

    get :scope, :show_hidden => true
    puts response.body
    assigns('nodes').should_not be_nil
    assigns('show_hidden').should be_false
  end

  it "should allow projects coordinator to see hidden event groups" do
    setup_eg; setup_viewer;

    @viewer.stub!(:is_projects_coordinator? => true)

    EventGroup.should_receive(:find_all_by_parent_id).and_return([ @eg ])
    @eg.stub!(:expanded= => nil, :children => [])

    get :scope, :show_hidden => true
    assigns('nodes').should_not be_nil
    assigns('show_hidden').should be_true
  end
end
