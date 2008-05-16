class RenameRefTypeInApplnReference < ActiveRecord::Migration
  def self.up
    rename_column :appln_references, :ref_type, :type
  end

  def self.down
    rename_column :appln_references, :type, :ref_type
  end
end
