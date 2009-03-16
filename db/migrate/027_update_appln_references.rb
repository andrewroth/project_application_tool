class UpdateApplnReferences < ActiveRecord::Migration
  def self.up
    # rename leader to satff
    rename_column :applns, :leader_reference_id, :staff_reference_id
    remove_column :applns, :employer_reference_id
  end
  
  def self.down
    rename_column :applns, :staff_reference_id, :leader_reference_id
    add_column :applns, :employer_reference_id, :integer
  end
end
