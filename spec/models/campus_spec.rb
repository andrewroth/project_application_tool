require File.dirname(__FILE__) + '/../spec_helper'

describe Campus, "testing" do
  set_fixture_class({ :cim_hrdb_campus => Campus, :cim_hrdb_person => Person })
  fixtures :cim_hrdb_campus
  fixtures :cim_hrdb_person

  it "should pass a tautology test" do
    Campus.find(:first).students
  end
end
