class ChangeCostItemAmountToInteger < ActiveRecord::Migration
  def self.up
    change_column :cost_items, :amount, :decimal, :precision => 8, :scale => 2
    change_column :manual_donations, :amount, :decimal, :precision => 8, :scale => 2
    change_column :manual_donations, :original_amount, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    change_column :cost_items, :amount, :float
    change_column :manual_donations, :amount, :float
    change_column :manual_donations, :original_amount, :float
  end
end
