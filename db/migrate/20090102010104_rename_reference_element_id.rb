class RenameReferenceElementId < ActiveRecord::Migration
  def self.up
    rename_column ReferenceInstance.table_name, :element_id, :reference_id
  end

  def self.down
    rename_column ReferenceInstance.table_name, :reference_id, :element_id
  end
end
