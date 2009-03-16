require File.dirname(__FILE__) + '/../spec_helper'

describe Campus, "testing" do
  load_fixtures :cim_hrdb_campus, :cim_hrdb_person, :cim_hrdb_assignment, :cim_hrdb_assignmentstatus,
                :accountadmin_viewer

  it "should return only people assigned as 'Current Student' or 'Unknown Status' on students call" do
    students = Campus.find(:first).students

    students.find{ |s| s.person_fname == 'Student' }.should_not be_nil
    students.find{ |s| s.person_fname == 'Bob' }.should be_nil
  end
end
