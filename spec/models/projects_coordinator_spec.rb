require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProjectsCoordinator do
  before(:each) do
    @valid_attributes = {
      :viewer_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ProjectsCoordinator.create!(@valid_attributes)
  end
end
