class AddAcceptanceIdToCostItems < ActiveRecord::Migration
  def self.up
    add_column :cost_items, :acceptance_id, :integer
  end

  def self.down
    remove_column :cost_items, :acceptance_id
  end
end
