require File.dirname(__FILE__) + '/../spec_helper'

# note: YearCostItem is more accurately thought of as an EventGropuCostItem
describe OptinCostItem, "testing" do
  load_fixtures :cim_hrdb_campus, :cim_hrdb_person, :cim_hrdb_assignment, :cim_hrdb_assignmentstatus,
                :accountadmin_viewer, :event_groups, :projects, :cost_items, :profiles

  def test_optin_by_cost_item_type(klass)
    cost_item = klass.find :first
    cost_item.optional = false

    profile = Profile.find :first
    profile.update_costing_total_cache
    orig_amount = profile.cached_costing_total

    cost_item.optional = true
    cost_item.save! 

    profile.reload
    profile.cached_costing_total.should == orig_amount - cost_item.amount

    OptinCostItem.create :profile_id => profile.id, :cost_item_id => cost_item.id
    # note - above line should trigger a profile.update_costing_total_cache

    profile.reload
    profile.cached_costing_total.should == orig_amount
  end

  it "should update total when opting in or out YearCostItem" do
    test_optin_by_cost_item_type YearCostItem
  end
  it "should update total when opting in or out ProjectCostItem" do
    test_optin_by_cost_item_type ProjectCostItem
  end
  it "should update total when opting in or out ProfileCostItem" do
    test_optin_by_cost_item_type ProfileCostItem
  end
end
