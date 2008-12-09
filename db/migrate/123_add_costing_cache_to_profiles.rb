class AddCostingCacheToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :cached_costing_total, :double
  end

  def self.down
    remove_column :profiles, :cached_costing_total
  end
end
