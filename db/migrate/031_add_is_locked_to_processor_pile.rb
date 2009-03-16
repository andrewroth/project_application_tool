class AddIsLockedToProcessorPile < ActiveRecord::Migration
  def self.up
    add_column :processor_piles, :locked_by_viewer_id, :integer, :default => nil
  end

  def self.down
    remove_column :processor_piles, :locked_by_viewer_id
  end
end
