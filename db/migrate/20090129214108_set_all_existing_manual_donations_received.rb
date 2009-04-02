class SetAllExistingManualDonationsReceived < ActiveRecord::Migration
  def self.up
    execute "update #{ManualDonation.table_name} set status = 'received'"
  end

  def self.down
  end
end
