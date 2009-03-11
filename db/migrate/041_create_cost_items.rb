class CreateCostItems < ActiveRecord::Migration
  def self.up
    create_table :cost_items do |t|
      t.column :type, :string
      t.column :description, :string
      t.column :amount, :float
      t.column :optional, :boolean
    end
  end

  def self.down
    drop_table :cost_items
  end
end
