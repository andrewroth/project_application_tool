class RenameRecievedToReceived < ActiveRecord::Migration
  def self.up
    rename_column("profile_prep_items", "recieved", "received")
  end

  def self.down
    rename_column("profile_prep_items", "received", "recieved")
  end
end
