# a cost-item that applies to a specific project
# 
class ProjectCostItem < CostItem
  belongs_to :project
end
