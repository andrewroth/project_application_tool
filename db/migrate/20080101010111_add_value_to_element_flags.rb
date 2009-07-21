class AddValueToElementFlags < ActiveRecord::Migration
  def self.up
    add_column ElementFlag.table_name, :value, :boolean
  end

  def self.down
    remove_column ElementFlag.table_name, :value
  end
end
