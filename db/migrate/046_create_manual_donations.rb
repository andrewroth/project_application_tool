class CreateManualDonations < ActiveRecord::Migration
  def self.up
    create_table :manual_donations do |t|
      t.column :motivation_code   , :string
      t.column :created_at        , :datetime
      t.column :donor_name        , :string
      t.column :donation_type_id  , :integer
      t.column :original_amount   , :float
      t.column :amount            , :float
    end
  end

  def self.down
    drop_table :manual_donations
  end
end
