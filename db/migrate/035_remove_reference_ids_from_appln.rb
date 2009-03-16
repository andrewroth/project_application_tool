class RemoveReferenceIdsFromAppln < ActiveRecord::Migration
  def self.up
    remove_column :applns, :peer_reference_id
    remove_column :applns, :pastor_reference_id
    remove_column :applns, :staff_reference_id
  end

  def self.down
    add_column :applns, :peer_reference_id, :integer
    add_column :applns, :pastor_reference_id, :integer
    add_column :applns, :staff_reference_id, :integer
  end
end
