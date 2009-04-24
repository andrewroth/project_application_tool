require File.dirname(__FILE__) + '/../spec_helper'

module PrepItemSpecHelper
  def valid_prep_item_attributes 
    { :title => "title", :description => "description", :event_group_id => 1 }
  end
  
end


describe PrepItem do

  include PrepItemSpecHelper

  before do
    # use fixtures, not mock/stubs when testing models
  end
  
  it "should be valid" do
    #@prep_item.attributes = valid_prep_item_attributes
    #@prep_item.save
    #@prep_item.should be_valid
  end
  
  it "should validate title" do
    #@prep_item.should have(1).error_on(:title)
  end
  
  it "should validate description" do
    #@prep_item.should have(1).error_on(:description)
  end
  
  it "should not create a new prep item if one with an identical title already exists" do
=begin
    @prep_item.attributes = valid_prep_item_attributes
    @prep_item.save!
    prep1 = PrepItem.new :title => 'prep_item'
    prep1.attributes = valid_prep_item_attributes
    lambda { prep1.save }.should_not change(PrepItem, :count)
=end
  end
  
  it "should create a new prep item if one with an identical title but is in a different eg already exists" do
=begin
    @prep_item.attributes = valid_prep_item_attributes
    @prep_item.save!
    prep1 = PrepItem.new
    prep1.attributes = valid_prep_item_attributes
    prep1.event_group_id = 23
    lambda { prep1.save }.should change(PrepItem, :count)
=end
  end
  
  it "should apply to event group" do
    #@prep_item.attributes = valid_prep_item_attributes
    #@prep_item.applies_to == :event_group
  end
  
  it "should be able to assign profile prep items" do
    #@prep_item.profile_prep_items.should be_empty
  end
  
end
