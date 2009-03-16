class AddReferencesToAppln < ActiveRecord::Migration
  def self.up
    add_column :applns, :peer_reference_id, :integer
    add_column :applns, :pastor_reference_id, :integer
    add_column :applns, :leader_reference_id, :integer
    add_column :applns, :employer_reference_id, :integer
  end

  def self.down
    remove_column :applns, :peer_reference_id
    remove_column :applns, :pastor_reference_id
    remove_column :applns, :leader_reference_id
    remove_column :applns, :employer_reference_id
  end
end
