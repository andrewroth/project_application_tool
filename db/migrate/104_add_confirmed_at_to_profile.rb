class AddConfirmedAtToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :confirmed_at, :datetime 
  end

  def self.down
    remove_column :profiles, :confirmed_at
  end
end
