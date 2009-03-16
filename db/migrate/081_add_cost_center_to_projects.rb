class AddCostCenterToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :cost_center, :string
  end

  def self.down
    remove_column :projects, :cost_center
  end
end
