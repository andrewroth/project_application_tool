require File.dirname(__FILE__) + '/../spec_helper'

module CostItemSpecHelper
  def valid_cost_item_attributes 
    { :description => "description", :
  end
end


describe CostItem do

  include CostItemSpecHelper

  before(:each) do
    @cost_item = CostItem.new
  end
  
  it "should be valid" do
    @cost_item.should be_valid
  end
  
  
  it "should assign title to new cost items" do
    @cost_item.description.should equal("no description")
  end
  
  
  
end