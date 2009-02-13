class SetAllExistingManualDonationsReceived < ActiveRecord::Migration
  def self.up
    for d in ManualDonation.find(:all)
      execute "update #{ManualDonation.table_name} set status = 'received'"
    end
  end

  def self.down
  end
end
