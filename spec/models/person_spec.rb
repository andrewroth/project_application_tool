require File.dirname(__FILE__) + '/../spec_helper'

describe Person, "testing" do
  load_fixtures :cim_hrdb_campus, :cim_hrdb_person, :cim_hrdb_assignment, :cim_hrdb_assignmentstatus,
                :accountadmin_viewer

  it "should return current campus on campus call" do
    s7 = Person.find_by_person_fname_and_person_lname 'Student', 'Seven'
    s7.should_not be_nil
    s7.campus.should_not be_nil
    s7.campus_longDesc.should == "Never never land"
  end
end
