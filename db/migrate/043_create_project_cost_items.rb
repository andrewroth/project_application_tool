class CreateProjectCostItems < ActiveRecord::Migration
  def self.up
    add_column :cost_items, :project_id, :integer
  end

  def self.down
    remove_column :cost_items, :project_id
  end
end
