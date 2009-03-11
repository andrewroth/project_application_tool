class AddWithdrawnAtToAppln < ActiveRecord::Migration
  def self.up
    add_column :applns, :withdrawn_at, :datetime
  end
  
  def self.down
    remove_column :applns, :withdrawn_at
  end
end
