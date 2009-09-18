class AddCostItemIdToReportElement < ActiveRecord::Migration
  def self.up
    add_column :report_elements, :cost_item_id, :integer
  end

  def self.down
    remove_column :report_elements, :cost_item_id
  end
end
