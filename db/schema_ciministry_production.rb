# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define() do

  create_table "accountadmin_accessgroup", :primary_key => "accessgroup_id", :force => true do |t|
    t.integer "accesscategory_id",               :default => 0,  :null => false
    t.string  "accessgroup_key",   :limit => 50, :default => "", :null => false
  end

  add_index "accountadmin_accessgroup", ["accessgroup_key"], :name => "ciministry.accountadmin_accessgroup_accessgroup_ke"

  create_table "accountadmin_viewer", :primary_key => "viewer_id", :force => true do |t|
    t.string  "guid",             :limit => 64, :default => "", :null => false
    t.integer "accountgroup_id",                :default => 0,  :null => false
    t.string  "viewer_userID",    :limit => 50, :default => "", :null => false
    t.string  "viewer_passWord",  :limit => 50, :default => "", :null => false
    t.integer "language_id",                    :default => 0,  :null => false
    t.integer "viewer_isActive",  :limit => 1,  :default => 0,  :null => false
    t.date    "viewer_lastLogin",                               :null => false
  end

  add_index "accountadmin_viewer", ["accountgroup_id"], :name => "ciministry.accountadmin_viewer_accountgroup_id_index"
  add_index "accountadmin_viewer", ["viewer_userID"], :name => "ciministry.accountadmin_viewer_viewer_userID_index"

  create_table "accountadmin_vieweraccessgroup", :primary_key => "vieweraccessgroup_id", :force => true do |t|
    t.integer "viewer_id",      :default => 0, :null => false
    t.integer "accessgroup_id", :default => 0, :null => false
  end

  add_index "accountadmin_vieweraccessgroup", ["viewer_id"], :name => "ciministry.accountadmin_vieweraccessgroup_viewer_i"
  add_index "accountadmin_vieweraccessgroup", ["accessgroup_id"], :name => "ciministry.accountadmin_vieweraccessgroup_accessgr"

  create_table "cim_hrdb_access", :primary_key => "access_id", :force => true do |t|
    t.integer "viewer_id", :limit => 50, :default => 0, :null => false
    t.integer "person_id", :limit => 50, :default => 0, :null => false
  end

  add_index "cim_hrdb_access", ["viewer_id"], :name => "ciministry.cim_hrdb_access_viewer_id_index"
  add_index "cim_hrdb_access", ["person_id"], :name => "ciministry.cim_hrdb_access_person_id_index"

  create_table "cim_hrdb_assignment", :primary_key => "assignment_id", :force => true do |t|
    t.integer "person_id",           :limit => 50, :default => 0, :null => false
    t.integer "campus_id",           :limit => 50, :default => 0, :null => false
    t.integer "assignmentstatus_id", :limit => 10, :default => 0, :null => false
  end

  add_index "cim_hrdb_assignment", ["person_id"], :name => "ciministry.cim_hrdb_assignment_person_id_index"
  add_index "cim_hrdb_assignment", ["campus_id"], :name => "ciministry.cim_hrdb_assignment_campus_id_index"

  create_table "cim_hrdb_campus", :primary_key => "campus_id", :force => true do |t|
    t.string  "campus_desc",          :limit => 128, :default => "", :null => false
    t.string  "campus_shortDesc",     :limit => 50,  :default => "", :null => false
    t.integer "accountgroup_id",      :limit => 16,  :default => 0,  :null => false
    t.integer "region_id",            :limit => 8,   :default => 0,  :null => false
    t.string  "campus_website",       :limit => 128, :default => "", :null => false
    t.string  "campus_facebookgroup", :limit => 128, :default => "", :null => false
    t.string  "campus_gcxnamespace",  :limit => 128, :default => "", :null => false
  end

  add_index "cim_hrdb_campus", ["region_id"], :name => "ciministry.cim_hrdb_campus_region_id_index"
  add_index "cim_hrdb_campus", ["accountgroup_id"], :name => "ciministry.cim_hrdb_campus_accountgroup_id_index"

  create_table "cim_hrdb_emerg", :primary_key => "emerg_id", :force => true do |t|
    t.integer "person_id",            :limit => 16, :default => 0,  :null => false
    t.string  "emerg_passportNum",    :limit => 32, :default => "", :null => false
    t.string  "emerg_passportOrigin", :limit => 32, :default => "", :null => false
    t.date    "emerg_passportExpiry",                               :null => false
    t.string  "emerg_contactName",    :limit => 64, :default => "", :null => false
    t.string  "emerg_contactRship",   :limit => 64, :default => "", :null => false
    t.string  "emerg_contactHome",    :limit => 32, :default => "", :null => false
    t.string  "emerg_contactWork",    :limit => 32, :default => "", :null => false
    t.string  "emerg_contactMobile",  :limit => 32, :default => "", :null => false
    t.string  "emerg_contactEmail",   :limit => 32, :default => "", :null => false
    t.date    "emerg_birthdate",                                    :null => false
    t.text    "emerg_medicalNotes",                 :default => "", :null => false
  end

  add_index "cim_hrdb_emerg", ["person_id"], :name => "ciministry.cim_hrdb_emerg_person_id_index"

  create_table "cim_hrdb_gender", :primary_key => "gender_id", :force => true do |t|
    t.string "gender_desc", :limit => 50, :default => "", :null => false
  end

  create_table "cim_hrdb_person", :primary_key => "person_id", :force => true do |t|
    t.string  "person_fname",             :limit => 50,  :default => "", :null => false
    t.string  "person_lname",             :limit => 50,  :default => "", :null => false
    t.string  "person_legal_fname",       :limit => 50,  :default => "", :null => false
    t.string  "person_legal_lname",       :limit => 50,  :default => "", :null => false
    t.string  "person_phone",             :limit => 50,  :default => "", :null => false
    t.string  "person_email",             :limit => 128, :default => "", :null => false
    t.string  "person_addr",              :limit => 128, :default => "", :null => false
    t.string  "person_city",              :limit => 50,  :default => "", :null => false
    t.integer "province_id",              :limit => 50,  :default => 0,  :null => false
    t.string  "person_pc",                :limit => 50,  :default => "", :null => false
    t.integer "gender_id",                :limit => 50,  :default => 0,  :null => false
    t.string  "person_local_phone",       :limit => 50,  :default => "", :null => false
    t.string  "person_local_addr",        :limit => 128, :default => "", :null => false
    t.string  "person_local_city",        :limit => 50,  :default => "", :null => false
    t.string  "person_local_pc",          :limit => 50,  :default => "", :null => false
    t.integer "person_local_province_id", :limit => 50,  :default => 0,  :null => false
  end

  add_index "cim_hrdb_person", ["gender_id"], :name => "ciministry.cim_hrdb_person_gender_id_index"
  add_index "cim_hrdb_person", ["province_id"], :name => "ciministry.cim_hrdb_person_province_id_index"

  create_table "cim_hrdb_province", :primary_key => "province_id", :force => true do |t|
    t.string "province_desc",      :limit => 50, :default => "", :null => false
    t.string "province_shortDesc", :limit => 50, :default => "", :null => false
  end

  create_table "site_multilingual_label", :primary_key => "label_id", :force => true do |t|
    t.integer   "page_id",                     :default => 0,  :null => false
    t.string    "label_key",     :limit => 50, :default => "", :null => false
    t.text      "label_label",                 :default => "", :null => false
    t.timestamp "label_moddate",                               :null => false
    t.integer   "language_id",                 :default => 0,  :null => false
  end

  add_index "site_multilingual_label", ["page_id"], :name => "ciministry.site_multilingual_label_page_id_index"
  add_index "site_multilingual_label", ["label_key"], :name => "ciministry.site_multilingual_label_label_key_index"
  add_index "site_multilingual_label", ["language_id"], :name => "ciministry.site_multilingual_label_language_id_index"

  create_table "spt_ticket", :primary_key => "ticket_id", :force => true do |t|
    t.integer "viewer_id",     :limit => 8,  :default => 0,  :null => false
    t.string  "ticket_ticket", :limit => 64, :default => "", :null => false
    t.integer "ticket_expiry", :limit => 16, :default => 0,  :null => false
  end

end
