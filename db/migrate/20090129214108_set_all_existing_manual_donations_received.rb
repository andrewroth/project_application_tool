class SetAllExistingManualDonationsReceived < ActiveRecord::Migration
  def self.up
    for d in ManualDonation.find(:all)
      d.status = 'received'
    end
  end

  def self.down
  end
end
