class SetInitialCostingCacheValue < ActiveRecord::Migration
  def self.up
    projects = Project.find(:all)
    ProjectCostItem.update_costing_total_cache_by_project(projects, true)
  end

  def self.down
  end
end
