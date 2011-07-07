class ProfileCostItem < CostItem
  belongs_to :profile

  def short_type() "profile" end

  def update_costing_total_cache
    # easy, just updates one profile's cache
    profile.profile_cost_items.reload
    profile.update_costing_total_cache
  end
end
