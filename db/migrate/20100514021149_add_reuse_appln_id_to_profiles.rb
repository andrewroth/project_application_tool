class AddReuseApplnIdToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :reuse_appln_id, :integer
  end

  def self.down
    remove_column :profiles, :reuse_appln_id
  end
end
