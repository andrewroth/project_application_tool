class SetInitialConversionRateForManualDonations < ActiveRecord::Migration
  def self.up
    execute "update manual_donations set conversion_rate = amount / original_amount"
  end

  def self.down
  end
end
