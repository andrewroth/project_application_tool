class AddEmerg < ActiveRecord::Migration
  def self.up
    create_table "emergs" do |t|
      t.integer "person_id"
      t.string "passport_num"
      t.string "passport_origin"
      t.string "passport_expiry"
      t.text "notes"
      t.text "meds"
      t.string "health_coverage_state" # in Cdn schema this is _id integer
      t.string "health_number"
      t.string  "medical_plan_number"
      t.string  "medical_plan_carrier"
      t.string  "doctor_name"
      t.string  "doctor_phone"
      t.string  "dentist_name"
      t.string  "dentist_phone"
      t.string  "blood_type"
      t.string  "blood_rh_factor"
    end
  end

  def self.down
    drop_table "emergs"
  end
end
