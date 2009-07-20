class AddTypeToReferenceInstances < ActiveRecord::Migration
  def self.up
    add_column ReferenceInstance.table_name, :type, :string
  end

  def self.down
    remove_column ReferenceInstance.table_name, :type
  end
end
