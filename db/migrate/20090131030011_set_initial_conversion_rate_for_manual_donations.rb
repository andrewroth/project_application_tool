class SetInitialConversionRateForManualDonations < ActiveRecord::Migration
  def self.up
    for d in ManualDonation.find(:all)
      if d.original_amount == 0 || d.amount == 0 || d.amount.class == String || d.original_amount.class == String
        d.conversion_rate = 1.0
      else
        d.conversion_rate = d.amount / d.original_amount
      end

      d.save!
    end
  end

  def self.down
  end
end
