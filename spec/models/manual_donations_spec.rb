require File.dirname(__FILE__) + '/../spec_helper'

# note: YearCostItem is more accurately thought of as an EventGropuCostItem
describe ManualDonation, "testing" do
  load_fixtures :cim_hrdb_campus, :cim_hrdb_person, :cim_hrdb_assignment, :cim_hrdb_assignmentstatus,
                :accountadmin_viewer, :event_groups, :projects, :cost_items, :profiles, :manual_donations

  it "should not include invalid donations in total" do
    p = Profile.find :first
    p.donations_total.should == 100
  end

end
