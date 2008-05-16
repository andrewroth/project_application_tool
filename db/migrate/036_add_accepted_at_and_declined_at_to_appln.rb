class AddAcceptedAtAndDeclinedAtToAppln < ActiveRecord::Migration
  def self.up
    add_column :applns, :accepted_at, :datetime
    add_column :applns, :declined_at, :datetime
  end

  def self.down
    remove_column :applns, :accepted_at
    remove_column :applns, :declined_at
  end
end
