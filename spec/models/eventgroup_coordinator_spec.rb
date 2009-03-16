require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventgroupCoordinator do
  before(:each) do
    @valid_attributes = {
      :viewer_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    EventgroupCoordinator.create!(@valid_attributes)
  end
end
