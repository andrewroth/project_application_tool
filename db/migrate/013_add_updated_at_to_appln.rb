class AddUpdatedAtToAppln < ActiveRecord::Migration
  def self.up
    add_column :applns, :updated_at, :datetime
  end

  def self.down
    remove_column :applns, :updated_at
  end
end
