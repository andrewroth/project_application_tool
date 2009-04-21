require File.dirname(__FILE__) + '/../spec_helper'

module CostItemSpecHelper
  def valid_cost_item_attributes 
    { :description => "description" }
  end
end


describe CostItem do

  include CostItemSpecHelper

  before(:each) do
    @cost_item = CostItem.new
    @profile = mock_model(Profile, :id => 1)
  end
  
  it "should be valid" do
    @cost_item.should be_valid
  end
  
  
  it "should assign title to new cost items" do
    @cost_item.description.should == "no description"
  end
  
  
  
end