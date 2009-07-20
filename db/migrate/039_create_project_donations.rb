class CreateProjectDonations < ActiveRecord::Migration
  def self.up
    create_table "project_donations", :force => true do |t|
      t.string   "participant_motv_code",     :limit => 10,  :default => "",  :null => false
      t.string   "participant_external_id",   :limit => 10,  :default => "",  :null => false
      t.datetime "donation_date"
      t.string   "donation_reference_number", :limit => 10,  :default => ""
      t.string   "donor_name",                :limit => 100, :default => ""
      t.string   "donation_type",             :limit => 10,  :default => ""
      t.float    "original_amount",                          :default => 0.0
      t.float    "amount",                                   :default => 0.0
    end
  end

  def self.down
    drop_table :project_donations
  end
end
