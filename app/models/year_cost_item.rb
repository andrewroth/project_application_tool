# a cost-item that applies to all projects in the given year
# note: when we added event groups, it changed this from being for a given year
#    to a given event group.  So a more accurate class name would be EventGroupCostItem
# 
class YearCostItem < ProjectCostItem
  belongs_to :event_group

  def update_costing_total_cache
    return false unless event_group

    # update all projects in the event group
    ProjectCostItem.update_costing_total_cache_by_project event_group.projects
  end

end
