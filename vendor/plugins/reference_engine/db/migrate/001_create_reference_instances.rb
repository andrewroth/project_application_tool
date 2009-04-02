class CreateReferenceInstances < ActiveRecord::Migration
  def self.up
    # look for an ApplnReference table, this is specific to the Canadian summer project tool
    # but necessary for us to keep existing values
      rename_table :appln_references, ReferenceInstance.table_name
  end

  def self.down
    rename_table ReferenceInstance.table_name, :appln_references
  end
end

