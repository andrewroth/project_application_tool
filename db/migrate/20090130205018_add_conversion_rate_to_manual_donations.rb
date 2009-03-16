class AddConversionRateToManualDonations < ActiveRecord::Migration
  def self.up
    add_column :manual_donations, :conversion_rate, :float
  end

  def self.down
    remove_column :manual_donations, :conversion_rate
  end
end
