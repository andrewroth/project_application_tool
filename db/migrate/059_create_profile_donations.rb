class CreateProfileDonations < ActiveRecord::Migration
  def self.up
    create_table :profile_donations do |t|
      t.column :profile_id, :integer
      t.column :type, :string
      t.column :auto_donation_id, :integer
      t.column :manual_donation_id, :integer
    end
  end
  
  def self.down
    drop_table :profile_donations
  end
end
