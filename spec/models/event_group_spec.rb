require File.dirname(__FILE__) + '/../spec_helper'

describe EventGroup, "testing" do
  fixtures :event_groups

  it "should pass a tautology test" do
    true
  end

  it "should hide hidden children" do
    p = EventGroup.find :first
    p.filter_hidden = true
    p.children.length.should be(1) 
    p.children.first.title.should == 'not hidden eg'
  end

  it "should ignore hidden when filter_hidden is false" do
    p = EventGroup.find :first
    p.filter_hidden = false
    p.children.length.should be(2) 
  end

  it "should not crash on update" do
    p = EventGroup.find :first

    p.update_attributes "title" => "2008 AIA Tour Application (Basketball, Volleyball, Football)", "uploaded_data" => "", "default_text_area_length" => "4000", "outgoing_email" => "chrisw@athletesinaction.com", "parent_id" => "44", "long_desc" => "a 2008 international tour", "ministry_id" => "", "has_your_campuses" => "0", "hidden" => "0"
  end
end
