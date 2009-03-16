class CreateOptinCostItems < ActiveRecord::Migration
  def self.up
    create_table :optin_cost_items do |t|
      t.column :acceptance_id, :integer
      t.column :cost_item_id, :integer
    end
  end

  def self.down
    drop_table :optin_cost_items
  end
end
