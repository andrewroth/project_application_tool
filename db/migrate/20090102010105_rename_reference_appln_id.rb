class RenameReferenceApplnId < ActiveRecord::Migration
  def self.up
    rename_column ReferenceInstance.table_name, :appln_id, :instance_id
  end

  def self.down
    rename_column ReferenceInstance.table_name, :instance_id, :appln_id
  end
end
