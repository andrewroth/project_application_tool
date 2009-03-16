class AddStatesToManualDonations < ActiveRecord::Migration
  def self.up
    add_column :manual_donations, :status, :string
  end

  def self.down
    remove_column :manual_donations
  end
end
