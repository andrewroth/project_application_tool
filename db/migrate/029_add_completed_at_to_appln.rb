class AddCompletedAtToAppln < ActiveRecord::Migration
  def self.up
    add_column :applns, :completed_at, :datetime
  end

  def self.down
    remove_column :applns, :completed_at
  end
end
