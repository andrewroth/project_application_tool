class AddSubmittedAtToAppln < ActiveRecord::Migration
  def self.up
    add_column :applns, :submitted_at, :datetime
  end

  def self.down
    remove_column :applns, :submitted_at
  end
end
