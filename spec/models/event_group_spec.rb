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
end
