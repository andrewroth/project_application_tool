class CreateYearCostItems < ActiveRecord::Migration
  def self.up
    add_column :cost_items, :year, :integer
  end

  def self.down
    remove_column :cost_items, :year
  end
end
