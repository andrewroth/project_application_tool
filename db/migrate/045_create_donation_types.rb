class CreateDonationTypes < ActiveRecord::Migration
  def self.up
    create_table :donation_types do |t|
      t.column :description,  :string
    end
    
    type = DonationType.create(:description => "CNDMANUAL")
    type.save!
    type = DonationType.create(:description => "USDMANUAL")
    type.save!
    type = DonationType.create(:description => "REGISTRN")
    type.save!
    type = DonationType.create(:description => "DASCO")
    type.save!
  end

  def self.down
    drop_table :donation_types
  end
end
