require File.dirname(__FILE__) + '/../spec_helper'

# note: YearCostItem is more accurately thought of as an EventGropuCostItem
describe ProfileCostItem, "testing" do
  load_fixtures :cim_hrdb_campus, :cim_hrdb_person, :cim_hrdb_assignment, :cim_hrdb_assignmentstatus,
                :accountadmin_viewer, :event_groups, :projects, :cost_items, :profiles

  it "should update all affected profiles on ProfileCostItem update and destroy" do
    profile = Profile.find :first
    profile.update_costing_total_cache
    orig_amount = profile.cached_costing_total

    cost_item = ProfileCostItem.find @loaded_fixtures['cost_items']['profile_1_cost_item']['id']
    cost_item_amount = cost_item.amount

    cost_item.amount += 50
    cost_item.save! 

    profile.reload
    profile.cached_costing_total.should == orig_amount + 50

    cost_item.destroy

    profile.reload
    profile.cached_costing_total.should == orig_amount - cost_item_amount
  end

  it "should update all affected profiles costing cache on ProfileCostItem create" do
    profile = Profile.find :first
    profile.update_costing_total_cache
    orig_amount = profile.cached_costing_total

    cost_item = ProfileCostItem.create :profile_id => Profile.find(:first).id, :optional => false,
                                       :amount => 50

    profile = Profile.find :first
    profile.cached_costing_total.should == orig_amount + 50 # the one from fixtures already is 50
  end

end
