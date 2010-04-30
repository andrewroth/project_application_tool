# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "accountadmin_accesscategory", :primary_key => "accesscategory_id", :force => true do |t|
    t.string "accesscategory_key", :limit => 50, :default => "", :null => false
    t.text   "english_value"
  end

  add_index "accountadmin_accesscategory", ["accesscategory_key"], :name => "ciministry.accountadmin_accesscategory_accesscateg"

  create_table "accountadmin_accessgroup", :primary_key => "accessgroup_id", :force => true do |t|
    t.integer "accesscategory_id",               :default => 0,  :null => false
    t.string  "accessgroup_key",   :limit => 50, :default => "", :null => false
    t.text    "english_value"
  end

  add_index "accountadmin_accessgroup", ["accessgroup_key"], :name => "ciministry.accountadmin_accessgroup_accessgroup_ke"

  create_table "accountadmin_accountadminaccess", :primary_key => "accountadminaccess_id", :force => true do |t|
    t.integer "viewer_id",                    :default => 0, :null => false
    t.integer "accountadminaccess_privilege", :default => 0, :null => false
  end

  add_index "accountadmin_accountadminaccess", ["accountadminaccess_privilege"], :name => "ciministry.accountadmin_accountadminaccess_account"
  add_index "accountadmin_accountadminaccess", ["viewer_id"], :name => "ciministry.accountadmin_accountadminaccess_viewer_"

  create_table "accountadmin_accountgroup", :primary_key => "accountgroup_id", :force => true do |t|
    t.string "accountgroup_key",        :limit => 50, :default => "", :null => false
    t.string "accountgroup_label_long", :limit => 50, :default => "", :null => false
    t.text   "english_value"
  end

  create_table "accountadmin_language", :primary_key => "language_id", :force => true do |t|
    t.string "language_key",  :limit => 25, :default => "", :null => false
    t.string "language_code", :limit => 2,  :default => "", :null => false
    t.text   "english_value"
  end

  create_table "accountadmin_viewer", :primary_key => "viewer_id", :force => true do |t|
    t.string   "guid",                      :limit => 64,                 :null => false
    t.integer  "accountgroup_id",                         :default => 0,  :null => false
    t.string   "viewer_userID",             :limit => 50, :default => "", :null => false
    t.string   "viewer_passWord",           :limit => 50, :default => "", :null => false
    t.integer  "language_id",                             :default => 0,  :null => false
    t.integer  "viewer_isActive",                         :default => 0,  :null => false
    t.date     "viewer_lastLogin",                                        :null => false
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.boolean  "email_validated"
    t.boolean  "developer"
    t.string   "facebook_hash"
    t.string   "facebook_username"
  end

  add_index "accountadmin_viewer", ["accountgroup_id"], :name => "ciministry.accountadmin_viewer_accountgroup_id_index"
  add_index "accountadmin_viewer", ["viewer_userID"], :name => "ciministry.accountadmin_viewer_viewer_userID_index"

  create_table "accountadmin_vieweraccessgroup", :primary_key => "vieweraccessgroup_id", :force => true do |t|
    t.integer "viewer_id",      :default => 0, :null => false
    t.integer "accessgroup_id", :default => 0, :null => false
  end

  add_index "accountadmin_vieweraccessgroup", ["accessgroup_id"], :name => "ciministry.accountadmin_vieweraccessgroup_accessgr"
  add_index "accountadmin_vieweraccessgroup", ["viewer_id"], :name => "ciministry.accountadmin_vieweraccessgroup_viewer_i"

  create_table "cim_c4cwebsite_projects", :primary_key => "projects_id", :force => true do |t|
    t.string "projects_desc",   :limit => 50,  :default => "", :null => false
    t.string "project_website", :limit => 200
    t.string "project_name",    :limit => 50
  end

  create_table "cim_hrdb_access", :primary_key => "access_id", :force => true do |t|
    t.integer "viewer_id", :default => 0, :null => false
    t.integer "person_id", :default => 0, :null => false
  end

  add_index "cim_hrdb_access", ["person_id"], :name => "ciministry.cim_hrdb_access_person_id_index"
  add_index "cim_hrdb_access", ["viewer_id"], :name => "ciministry.cim_hrdb_access_viewer_id_index"

  create_table "cim_hrdb_activityschedule", :primary_key => "activityschedule_id", :force => true do |t|
    t.integer "staffactivity_id", :default => 0, :null => false
    t.integer "staffschedule_id", :default => 0, :null => false
  end

  add_index "cim_hrdb_activityschedule", ["staffactivity_id"], :name => "FK_schedule_activity"
  add_index "cim_hrdb_activityschedule", ["staffschedule_id"], :name => "FK_activity_schedule"

  create_table "cim_hrdb_activitytype", :primary_key => "activitytype_id", :force => true do |t|
    t.string "activitytype_desc",  :limit => 75, :default => "",        :null => false
    t.string "activitytype_abbr",  :limit => 6,                         :null => false
    t.string "activitytype_color", :limit => 7,  :default => "#0000FF", :null => false
  end

  create_table "cim_hrdb_admin", :primary_key => "admin_id", :force => true do |t|
    t.integer "person_id", :default => 0, :null => false
    t.integer "priv_id",   :default => 0, :null => false
  end

  add_index "cim_hrdb_admin", ["person_id"], :name => "FK_hrdbadmin_person"
  add_index "cim_hrdb_admin", ["priv_id"], :name => "FK_admin_priv"

  create_table "cim_hrdb_assignment", :primary_key => "assignment_id", :force => true do |t|
    t.integer "person_id",           :default => 0, :null => false
    t.integer "campus_id",           :default => 0, :null => false
    t.integer "assignmentstatus_id", :default => 0, :null => false
  end

  add_index "cim_hrdb_assignment", ["campus_id"], :name => "ciministry.cim_hrdb_assignment_campus_id_index"
  add_index "cim_hrdb_assignment", ["person_id"], :name => "ciministry.cim_hrdb_assignment_person_id_index"

  create_table "cim_hrdb_assignmentstatus", :primary_key => "assignmentstatus_id", :force => true do |t|
    t.string "assignmentstatus_desc", :limit => 64, :default => "", :null => false
  end

  create_table "cim_hrdb_campus", :primary_key => "campus_id", :force => true do |t|
    t.string  "campus_desc",          :limit => 128, :default => "", :null => false
    t.string  "campus_shortDesc",     :limit => 50,  :default => "", :null => false
    t.integer "accountgroup_id",                     :default => 0,  :null => false
    t.integer "region_id",                           :default => 0,  :null => false
    t.string  "campus_website",       :limit => 128, :default => "", :null => false
    t.string  "campus_facebookgroup", :limit => 128,                 :null => false
    t.string  "campus_gcxnamespace",  :limit => 128,                 :null => false
    t.integer "province_id"
  end

  add_index "cim_hrdb_campus", ["accountgroup_id"], :name => "ciministry.cim_hrdb_campus_accountgroup_id_index"
  add_index "cim_hrdb_campus", ["region_id"], :name => "ciministry.cim_hrdb_campus_region_id_index"

  create_table "cim_hrdb_campusadmin", :primary_key => "campusadmin_id", :force => true do |t|
    t.integer "admin_id",  :default => 0, :null => false
    t.integer "campus_id", :default => 0, :null => false
  end

  add_index "cim_hrdb_campusadmin", ["admin_id"], :name => "ciministry.cim_hrdb_campusadmin_admin_id_index"
  add_index "cim_hrdb_campusadmin", ["campus_id"], :name => "ciministry.cim_hrdb_campusadmin_campus_id_index"

  create_table "cim_hrdb_country", :primary_key => "country_id", :force => true do |t|
    t.string "country_desc",      :limit => 50, :default => "", :null => false
    t.string "country_shortDesc", :limit => 50, :default => "", :null => false
  end

  create_table "cim_hrdb_customfields", :primary_key => "customfields_id", :force => true do |t|
    t.integer "report_id", :null => false
    t.integer "fields_id", :null => false
  end

  add_index "cim_hrdb_customfields", ["fields_id"], :name => "FK_report_field"
  add_index "cim_hrdb_customfields", ["report_id"], :name => "FK_fields_report"

  create_table "cim_hrdb_customreports", :primary_key => "report_id", :force => true do |t|
    t.string  "report_name",     :limit => 64,                :null => false
    t.integer "report_is_shown",               :default => 0, :null => false
  end

  create_table "cim_hrdb_emerg", :primary_key => "emerg_id", :force => true do |t|
    t.integer "person_id",                          :default => 0,  :null => false
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
    t.text    "emerg_medicalNotes",                                 :null => false
    t.string  "emerg_contact2Name",   :limit => 64,                 :null => false
    t.string  "emerg_contact2Rship",  :limit => 64,                 :null => false
    t.string  "emerg_contact2Home",   :limit => 64,                 :null => false
    t.string  "emerg_contact2Work",   :limit => 64,                 :null => false
    t.string  "emerg_contact2Mobile", :limit => 64,                 :null => false
    t.string  "emerg_contact2Email",  :limit => 64,                 :null => false
    t.text    "emerg_meds",                                         :null => false
    t.integer "health_province_id"
    t.string  "health_number"
    t.string  "medical_plan_number"
    t.string  "medical_plan_carrier"
    t.string  "doctor_name"
    t.string  "doctor_phone"
    t.string  "dentist_name"
    t.string  "dentist_phone"
    t.string  "blood_type"
    t.string  "blood_rh_factor"
  end

  add_index "cim_hrdb_emerg", ["person_id"], :name => "ciministry.cim_hrdb_emerg_person_id_index"

  create_table "cim_hrdb_fieldgroup", :primary_key => "fieldgroup_id", :force => true do |t|
    t.string "fieldgroup_desc", :limit => 75, :null => false
  end

  create_table "cim_hrdb_fieldgroup_matches", :primary_key => "fieldgroup_matches_id", :force => true do |t|
    t.integer "fieldgroup_id", :default => 0, :null => false
    t.integer "fields_id",     :default => 0, :null => false
  end

  create_table "cim_hrdb_fields", :primary_key => "fields_id", :force => true do |t|
    t.integer "fieldtype_id",                        :default => 0,  :null => false
    t.text    "fields_desc",                                         :null => false
    t.integer "staffscheduletype_id",                :default => 0,  :null => false
    t.integer "fields_priority",                     :default => 0,  :null => false
    t.integer "fields_reqd",                         :default => 0,  :null => false
    t.string  "fields_invalid",       :limit => 128, :default => "", :null => false
    t.integer "fields_hidden",                       :default => 0,  :null => false
    t.integer "datatypes_id",                        :default => 0,  :null => false
    t.integer "fieldgroup_id",                       :default => 0,  :null => false
    t.string  "fields_note",          :limit => 75,                  :null => false
  end

  add_index "cim_hrdb_fields", ["datatypes_id"], :name => "FK_fields_dtype2"
  add_index "cim_hrdb_fields", ["fieldtype_id"], :name => "FK_fields_types2"
  add_index "cim_hrdb_fields", ["staffscheduletype_id"], :name => "FK_fields_form"

  create_table "cim_hrdb_fieldvalues", :primary_key => "fieldvalues_id", :force => true do |t|
    t.integer   "fields_id",           :default => 0, :null => false
    t.text      "fieldvalues_value",                  :null => false
    t.integer   "person_id",           :default => 0, :null => false
    t.timestamp "fieldvalues_modTime",                :null => false
  end

  add_index "cim_hrdb_fieldvalues", ["fields_id"], :name => "FK_fieldvals_field2"
  add_index "cim_hrdb_fieldvalues", ["person_id"], :name => "FK_fieldvals_person"

  create_table "cim_hrdb_gender", :primary_key => "gender_id", :force => true do |t|
    t.string "gender_desc", :limit => 50, :default => "", :null => false
  end

  create_table "cim_hrdb_ministry", :primary_key => "ministry_id", :force => true do |t|
    t.string "ministry_name",   :limit => 64, :null => false
    t.string "ministry_abbrev", :limit => 16, :null => false
  end

  create_table "cim_hrdb_person", :primary_key => "person_id", :force => true do |t|
    t.string  "person_fname",             :limit => 50,  :default => "", :null => false
    t.string  "person_lname",             :limit => 50,  :default => "", :null => false
    t.string  "person_legal_fname",       :limit => 50,                  :null => false
    t.string  "person_legal_lname",       :limit => 50,                  :null => false
    t.string  "person_phone",             :limit => 50,  :default => "", :null => false
    t.string  "person_email",             :limit => 128, :default => "", :null => false
    t.string  "person_addr",              :limit => 128, :default => "", :null => false
    t.string  "person_city",              :limit => 50,  :default => "", :null => false
    t.integer "province_id",                             :default => 0,  :null => false
    t.string  "person_pc",                :limit => 50,  :default => "", :null => false
    t.integer "gender_id",                               :default => 0,  :null => false
    t.string  "person_local_phone",       :limit => 50,  :default => "", :null => false
    t.string  "person_local_addr",        :limit => 128, :default => "", :null => false
    t.string  "person_local_city",        :limit => 50,  :default => "", :null => false
    t.string  "person_local_pc",          :limit => 50,  :default => "", :null => false
    t.integer "person_local_province_id",                :default => 0,  :null => false
    t.string  "cell_phone"
    t.date    "local_valid_until"
    t.integer "title_id"
    t.integer "country_id"
    t.integer "person_local_country_id"
    t.string  "person_mname"
  end

  add_index "cim_hrdb_person", ["gender_id"], :name => "ciministry.cim_hrdb_person_gender_id_index"
  add_index "cim_hrdb_person", ["province_id"], :name => "ciministry.cim_hrdb_person_province_id_index"

  create_table "cim_hrdb_person_year", :primary_key => "personyear_id", :force => true do |t|
    t.integer "person_id", :default => 0, :null => false
    t.integer "year_id",   :default => 0, :null => false
    t.date    "grad_date"
  end

  add_index "cim_hrdb_person_year", ["person_id"], :name => "FK_cim_hrdb_person_year"
  add_index "cim_hrdb_person_year", ["year_id"], :name => "1"

  create_table "cim_hrdb_priv", :primary_key => "priv_id", :force => true do |t|
    t.string "priv_accesslevel", :limit => 100, :default => "", :null => false
  end

  create_table "cim_hrdb_province", :primary_key => "province_id", :force => true do |t|
    t.string  "province_desc",      :limit => 50, :default => "", :null => false
    t.string  "province_shortDesc", :limit => 50, :default => "", :null => false
    t.integer "country_id"
  end

  create_table "cim_hrdb_region", :primary_key => "region_id", :force => true do |t|
    t.string  "reg_desc",   :limit => 64, :default => "", :null => false
    t.integer "country_id",               :default => 0,  :null => false
  end

  add_index "cim_hrdb_region", ["country_id"], :name => "FK_region_country"

  create_table "cim_hrdb_staff", :primary_key => "staff_id", :force => true do |t|
    t.integer "person_id", :default => 0, :null => false
    t.integer "is_active", :default => 1, :null => false
  end

  add_index "cim_hrdb_staff", ["person_id"], :name => "ciministry.cim_hrdb_staff_person_id_index"

  create_table "cim_hrdb_staffactivity", :primary_key => "staffactivity_id", :force => true do |t|
    t.integer "person_id",                                :default => 0, :null => false
    t.date    "staffactivity_startdate",                                 :null => false
    t.date    "staffactivity_enddate",                                   :null => false
    t.string  "staffactivity_contactPhone", :limit => 20,                :null => false
    t.integer "activitytype_id",                          :default => 0, :null => false
  end

  add_index "cim_hrdb_staffactivity", ["activitytype_id"], :name => "FK_activity_type"
  add_index "cim_hrdb_staffactivity", ["person_id"], :name => "FK_activity_person"

  create_table "cim_hrdb_staffdirector", :primary_key => "staffdirector_id", :force => true do |t|
    t.integer "staff_id",    :null => false
    t.integer "director_id", :null => false
  end

  add_index "cim_hrdb_staffdirector", ["director_id"], :name => "FK_director_staff"
  add_index "cim_hrdb_staffdirector", ["staff_id"], :name => "FK_staff_staff1"

  create_table "cim_hrdb_staffschedule", :primary_key => "staffschedule_id", :force => true do |t|
    t.integer   "person_id",                            :default => 0, :null => false
    t.integer   "staffscheduletype_id",                 :default => 0, :null => false
    t.integer   "staffschedule_approved",               :default => 0, :null => false
    t.integer   "staffschedule_approvedby",             :default => 0, :null => false
    t.timestamp "staffschedule_lastmodifiedbydirector",                :null => false
    t.text      "staffschedule_approvalnotes",                         :null => false
    t.integer   "staffschedule_tonotify",               :default => 0, :null => false
  end

  add_index "cim_hrdb_staffschedule", ["person_id"], :name => "FK_schedule_person1"
  add_index "cim_hrdb_staffschedule", ["staffscheduletype_id"], :name => "FK_schedule_type"

  create_table "cim_hrdb_staffscheduleinstr", :primary_key => "staffscheduletype_id", :force => true do |t|
    t.text "staffscheduleinstr_toptext",    :null => false
    t.text "staffscheduleinstr_bottomtext", :null => false
  end

  create_table "cim_hrdb_staffscheduletype", :primary_key => "staffscheduletype_id", :force => true do |t|
    t.string  "staffscheduletype_desc",               :limit => 75,                :null => false
    t.date    "staffscheduletype_startdate",                                       :null => false
    t.date    "staffscheduletype_enddate",                                         :null => false
    t.integer "staffscheduletype_has_activities",                   :default => 1, :null => false
    t.integer "staffscheduletype_has_activity_phone",               :default => 0, :null => false
    t.string  "staffscheduletype_activity_types",     :limit => 25,                :null => false
    t.integer "staffscheduletype_is_shown",                         :default => 0, :null => false
  end

  create_table "cim_hrdb_title", :force => true do |t|
    t.string "desc"
  end

  create_table "cim_hrdb_year_in_school", :primary_key => "year_id", :force => true do |t|
    t.string "year_desc", :limit => 50, :default => "", :null => false
  end

  create_table "cim_reg_activerules", :primary_key => "pricerules_id", :force => true do |t|
    t.integer "is_active",       :default => 0, :null => false
    t.integer "is_recalculated", :default => 1, :null => false
  end

  create_table "cim_reg_campusaccess", :primary_key => "campusaccess_id", :force => true do |t|
    t.integer "eventadmin_id", :default => 0, :null => false
    t.integer "campus_id",     :default => 0, :null => false
  end

  create_table "cim_reg_cashtransaction", :primary_key => "cashtransaction_id", :force => true do |t|
    t.integer   "reg_id",                                  :default => 0,   :null => false
    t.string    "cashtransaction_staffName", :limit => 64, :default => "",  :null => false
    t.integer   "cashtransaction_recd",                    :default => 0,   :null => false
    t.float     "cashtransaction_amtPaid",                 :default => 0.0, :null => false
    t.timestamp "cashtransaction_moddate",                                  :null => false
  end

  add_index "cim_reg_cashtransaction", ["reg_id"], :name => "FK_cashtrans_reg"

  create_table "cim_reg_ccreceipt", :primary_key => "cctransaction_id", :force => true do |t|
    t.string    "ccreceipt_sequencenum",  :limit => 18,                  :null => false
    t.string    "ccreceipt_authcode",     :limit => 8
    t.string    "ccreceipt_responsecode", :limit => 3,   :default => "", :null => false
    t.string    "ccreceipt_message",      :limit => 100, :default => "", :null => false
    t.timestamp "ccreceipt_moddate",                                     :null => false
  end

  create_table "cim_reg_cctransaction", :primary_key => "cctransaction_id", :force => true do |t|
    t.integer   "reg_id",                                :default => 0,   :null => false
    t.string    "cctransaction_cardName",  :limit => 64, :default => "",  :null => false
    t.integer   "cctype_id",                             :default => 0,   :null => false
    t.text      "cctransaction_cardNum",                                  :null => false
    t.string    "cctransaction_expiry",    :limit => 64, :default => "",  :null => false
    t.string    "cctransaction_billingPC", :limit => 64, :default => "",  :null => false
    t.integer   "cctransaction_processed",               :default => 0,   :null => false
    t.float     "cctransaction_amount",                  :default => 0.0, :null => false
    t.timestamp "cctransaction_moddate",                                  :null => false
    t.string    "cctransaction_refnum"
  end

  add_index "cim_reg_cctransaction", ["cctype_id"], :name => "FK_cctrans_ccid"
  add_index "cim_reg_cctransaction", ["reg_id"], :name => "FK_cctrans_reg"

  create_table "cim_reg_cctype", :primary_key => "cctype_id", :force => true do |t|
    t.string "cctype_desc", :limit => 32, :default => "", :null => false
  end

  create_table "cim_reg_datatypes", :primary_key => "datatypes_id", :force => true do |t|
    t.string "datatypes_key",  :limit => 8,  :default => "", :null => false
    t.string "datatypes_desc", :limit => 64, :default => "", :null => false
  end

  create_table "cim_reg_event", :primary_key => "event_id", :force => true do |t|
    t.integer  "country_id",                            :default => 0,   :null => false
    t.integer  "ministry_id",                           :default => 0,   :null => false
    t.string   "event_name",             :limit => 128, :default => "",  :null => false
    t.string   "event_descBrief",        :limit => 128, :default => "",  :null => false
    t.text     "event_descDetail",                                       :null => false
    t.datetime "event_startDate",                                        :null => false
    t.datetime "event_endDate",                                          :null => false
    t.datetime "event_regStart",                                         :null => false
    t.datetime "event_regEnd",                                           :null => false
    t.string   "event_website",          :limit => 128, :default => "",  :null => false
    t.text     "event_emailConfirmText",                                 :null => false
    t.float    "event_basePrice",                       :default => 0.0, :null => false
    t.float    "event_deposit",                         :default => 0.0, :null => false
    t.text     "event_contactEmail",                                     :null => false
    t.text     "event_pricingText",                                      :null => false
    t.integer  "event_onHomePage",                      :default => 1,   :null => false
    t.integer  "event_allowCash",                       :default => 0,   :null => false
  end

  create_table "cim_reg_eventadmin", :primary_key => "eventadmin_id", :force => true do |t|
    t.integer "event_id",  :default => 0, :null => false
    t.integer "priv_id",   :default => 0, :null => false
    t.integer "viewer_id", :default => 0, :null => false
  end

  add_index "cim_reg_eventadmin", ["event_id"], :name => "FK_admin_event"
  add_index "cim_reg_eventadmin", ["priv_id"], :name => "FK_evadmin_priv"
  add_index "cim_reg_eventadmin", ["viewer_id"], :name => "FK_admin_viewer"

  create_table "cim_reg_fields", :primary_key => "fields_id", :force => true do |t|
    t.integer "fieldtype_id",                   :default => 0,  :null => false
    t.text    "fields_desc",                                    :null => false
    t.integer "event_id",                       :default => 0,  :null => false
    t.integer "fields_priority",                :default => 0,  :null => false
    t.integer "fields_reqd",                    :default => 0,  :null => false
    t.string  "fields_invalid",  :limit => 128, :default => "", :null => false
    t.integer "fields_hidden",                  :default => 0,  :null => false
    t.integer "datatypes_id",                   :default => 0,  :null => false
  end

  add_index "cim_reg_fields", ["datatypes_id"], :name => "FK_fields_dtype"
  add_index "cim_reg_fields", ["event_id"], :name => "FK_fields_event"
  add_index "cim_reg_fields", ["fieldtype_id"], :name => "FK_fields_types"

  create_table "cim_reg_fieldtypes", :primary_key => "fieldtypes_id", :force => true do |t|
    t.string "fieldtypes_desc", :limit => 128, :default => "", :null => false
  end

  create_table "cim_reg_fieldvalues", :primary_key => "fieldvalues_id", :force => true do |t|
    t.integer   "fields_id",           :default => 0, :null => false
    t.text      "fieldvalues_value",                  :null => false
    t.integer   "registration_id",     :default => 0, :null => false
    t.timestamp "fieldvalues_modTime",                :null => false
  end

  add_index "cim_reg_fieldvalues", ["fields_id"], :name => "FK_fieldvals_field"
  add_index "cim_reg_fieldvalues", ["registration_id"], :name => "FK_fieldvals_reg"

  create_table "cim_reg_pricerules", :primary_key => "pricerules_id", :force => true do |t|
    t.integer "event_id",                           :default => 0,   :null => false
    t.integer "priceruletypes_id",                  :default => 0,   :null => false
    t.text    "pricerules_desc",                                     :null => false
    t.integer "fields_id",                          :default => 0,   :null => false
    t.string  "pricerules_value",    :limit => 128, :default => "",  :null => false
    t.float   "pricerules_discount",                :default => 0.0, :null => false
  end

  add_index "cim_reg_pricerules", ["event_id"], :name => "FK_prules_event"
  add_index "cim_reg_pricerules", ["priceruletypes_id"], :name => "FK_prules_type"

  create_table "cim_reg_priceruletypes", :primary_key => "priceruletypes_id", :force => true do |t|
    t.string "priceruletypes_desc", :limit => 128, :default => "", :null => false
  end

  create_table "cim_reg_priv", :primary_key => "priv_id", :force => true do |t|
    t.string "priv_desc", :limit => 64, :default => "", :null => false
  end

  create_table "cim_reg_registration", :primary_key => "registration_id", :force => true do |t|
    t.integer  "event_id",                              :default => 0,   :null => false
    t.integer  "person_id",                             :default => 0,   :null => false
    t.datetime "registration_date",                                      :null => false
    t.string   "registration_confirmNum", :limit => 64, :default => "",  :null => false
    t.integer  "registration_status",                   :default => 0,   :null => false
    t.float    "registration_balance",                  :default => 0.0, :null => false
  end

  add_index "cim_reg_registration", ["person_id"], :name => "FK_reg_person"
  add_index "cim_reg_registration", ["registration_status"], :name => "FK_reg_status"

  create_table "cim_reg_scholarship", :primary_key => "scholarship_id", :force => true do |t|
    t.integer "registration_id",                       :default => 0,   :null => false
    t.float   "scholarship_amount",                    :default => 0.0, :null => false
    t.string  "scholarship_sourceAcct", :limit => 64,  :default => "",  :null => false
    t.string  "scholarship_sourceDesc", :limit => 128, :default => "",  :null => false
  end

  add_index "cim_reg_scholarship", ["registration_id"], :name => "FK_scholarship_reg"

  create_table "cim_reg_status", :primary_key => "status_id", :force => true do |t|
    t.string "status_desc", :limit => 32, :default => "", :null => false
  end

  create_table "cim_reg_superadmin", :primary_key => "superadmin_id", :force => true do |t|
    t.integer "viewer_id", :default => 0, :null => false
  end

  add_index "cim_reg_superadmin", ["viewer_id"], :name => "FK_viewer_regsuperadmin"

  create_table "cim_stats_access", :primary_key => "access_id", :force => true do |t|
    t.integer "staff_id", :default => 0, :null => false
    t.integer "priv_id",  :default => 0, :null => false
  end

  create_table "cim_stats_coordinator", :primary_key => "coordinator_id", :force => true do |t|
    t.integer "access_id", :default => 0, :null => false
    t.integer "campus_id", :default => 0, :null => false
  end

  create_table "cim_stats_exposuretype", :primary_key => "exposuretype_id", :force => true do |t|
    t.string "exposuretype_desc", :limit => 64, :default => "", :null => false
  end

  create_table "cim_stats_month", :primary_key => "month_id", :force => true do |t|
    t.string  "month_desc",         :limit => 64, :default => "", :null => false
    t.integer "month_number",                     :default => 0,  :null => false
    t.integer "year_id",                          :default => 0,  :null => false
    t.integer "month_calendaryear",                               :null => false
    t.integer "semester_id"
  end

  create_table "cim_stats_morestats", :primary_key => "morestats_id", :force => true do |t|
    t.integer "morestats_exp",   :default => 0, :null => false
    t.text    "morestats_notes",                :null => false
    t.integer "week_id",         :default => 0, :null => false
    t.integer "campus_id",       :default => 0, :null => false
    t.integer "exposuretype_id", :default => 0, :null => false
  end

  create_table "cim_stats_prc", :primary_key => "prc_id", :force => true do |t|
    t.string  "prc_firstName",    :limit => 128, :default => "", :null => false
    t.integer "prcMethod_id",                    :default => 0,  :null => false
    t.string  "prc_witnessName",  :limit => 128, :default => "", :null => false
    t.integer "semester_id",                     :default => 0,  :null => false
    t.integer "campus_id",                       :default => 0,  :null => false
    t.text    "prc_notes",                                       :null => false
    t.integer "prc_7upCompleted",                :default => 0,  :null => false
    t.integer "prc_7upStarted",                  :default => 0,  :null => false
    t.date    "prc_date",                                        :null => false
  end

  create_table "cim_stats_prcmethod", :primary_key => "prcMethod_id", :force => true do |t|
    t.string "prcMethod_desc", :limit => 64, :default => "", :null => false
  end

  create_table "cim_stats_priv", :primary_key => "priv_id", :force => true do |t|
    t.string "priv_desc", :limit => 64, :default => "", :null => false
  end

  create_table "cim_stats_semester", :primary_key => "semester_id", :force => true do |t|
    t.string  "semester_desc",      :limit => 64, :default => "", :null => false
    t.date    "semester_startDate",                               :null => false
    t.integer "year_id",                          :default => 0,  :null => false
  end

  create_table "cim_stats_semesterreport", :primary_key => "semesterreport_id", :force => true do |t|
    t.integer "semesterreport_avgPrayer",        :default => 0, :null => false
    t.integer "semesterreport_avgWklyMtg",       :default => 0, :null => false
    t.integer "semesterreport_numStaffChall",    :default => 0, :null => false
    t.integer "semesterreport_numInternChall",   :default => 0, :null => false
    t.integer "semesterreport_numFrosh",         :default => 0, :null => false
    t.integer "semesterreport_numStaffDG",       :default => 0, :null => false
    t.integer "semesterreport_numInStaffDG",     :default => 0, :null => false
    t.integer "semesterreport_numStudentDG",     :default => 0, :null => false
    t.integer "semesterreport_numInStudentDG",   :default => 0, :null => false
    t.integer "semesterreport_numSpMultStaffDG", :default => 0, :null => false
    t.integer "semesterreport_numSpMultStdDG",   :default => 0, :null => false
    t.integer "semester_id",                     :default => 0, :null => false
    t.integer "campus_id",                       :default => 0, :null => false
  end

  create_table "cim_stats_week", :primary_key => "week_id", :force => true do |t|
    t.date    "week_endDate",                :null => false
    t.integer "semester_id",  :default => 0, :null => false
    t.integer "month_id",                    :null => false
  end

  create_table "cim_stats_weeklyreport", :primary_key => "weeklyReport_id", :force => true do |t|
    t.integer "weeklyReport_1on1SpConv",      :default => 0, :null => false
    t.integer "weeklyReport_1on1GosPres",     :default => 0, :null => false
    t.integer "weeklyReport_1on1HsPres",      :default => 0, :null => false
    t.integer "staff_id",                     :default => 0, :null => false
    t.integer "week_id",                      :default => 0, :null => false
    t.integer "campus_id",                    :default => 0, :null => false
    t.integer "weeklyReport_7upCompleted",    :default => 0, :null => false
    t.integer "weeklyReport_1on1SpConvStd",   :default => 0, :null => false
    t.integer "weeklyReport_1on1GosPresStd",  :default => 0, :null => false
    t.integer "weeklyReport_1on1HsPresStd",   :default => 0, :null => false
    t.integer "weeklyReport_7upCompletedStd", :default => 0, :null => false
    t.integer "weeklyReport_cjVideo",         :default => 0, :null => false
    t.integer "weeklyReport_mda",             :default => 0, :null => false
    t.integer "weeklyReport_otherEVMats",     :default => 0, :null => false
    t.integer "weeklyReport_rlk",             :default => 0, :null => false
    t.integer "weeklyReport_siq",             :default => 0, :null => false
    t.text    "weeklyReport_notes",                          :null => false
  end

  create_table "cim_stats_year", :primary_key => "year_id", :force => true do |t|
    t.string "year_desc", :limit => 32, :default => "", :null => false
  end

  create_table "multi_gen_buttons", :primary_key => "button_id", :force => true do |t|
    t.integer "site_id",                    :default => 0,  :null => false
    t.string  "button_key",   :limit => 50, :default => "", :null => false
    t.string  "button_value", :limit => 50, :default => "", :null => false
    t.integer "language_id",                :default => 1,  :null => false
  end

  create_table "multi_labels", :primary_key => "labels_id", :force => true do |t|
    t.integer "page_id",                      :default => 0,  :null => false
    t.integer "language_id",                  :default => 0,  :null => false
    t.string  "labels_key",     :limit => 50, :default => "", :null => false
    t.text    "labels_label",                                 :null => false
    t.text    "labels_caption"
  end

  add_index "multi_labels", ["language_id"], :name => "language_id"
  add_index "multi_labels", ["page_id"], :name => "page_id"

  create_table "multi_languages", :primary_key => "language_id", :force => true do |t|
    t.string "language_label", :limit => 128, :default => "", :null => false
    t.string "labels_key",     :limit => 128, :default => "", :null => false
  end

  create_table "multi_page", :primary_key => "page_id", :force => true do |t|
    t.integer "series_id",                :default => 0,  :null => false
    t.string  "page_label", :limit => 50, :default => "", :null => false
  end

  create_table "multi_series", :primary_key => "series_id", :force => true do |t|
    t.integer "site_id",                    :default => 0,  :null => false
    t.string  "series_label", :limit => 50, :default => "", :null => false
  end

  create_table "multi_site", :primary_key => "site_id", :force => true do |t|
    t.string "site_label", :limit => 128, :default => "", :null => false
  end

  create_table "national_day", :primary_key => "day_id", :force => true do |t|
    t.date "day_date", :null => false
  end

  create_table "national_signup", :primary_key => "signup_id", :force => true do |t|
    t.integer "day_id",                      :default => 0,  :null => false
    t.integer "time_id",                     :default => 0,  :null => false
    t.string  "signup_name",  :limit => 128, :default => "", :null => false
    t.integer "campus_id",                   :default => 0,  :null => false
    t.string  "signup_email", :limit => 128, :default => "", :null => false
  end

  create_table "national_time", :primary_key => "time_id", :force => true do |t|
    t.time "time_time", :default => '2000-01-01 00:00:00', :null => false
  end

  create_table "national_timezones", :primary_key => "timezones_id", :force => true do |t|
    t.string  "timezones_desc",   :limit => 32, :default => "", :null => false
    t.integer "timezones_offset",               :default => 0,  :null => false
  end

  create_table "navbar_navbarcache", :primary_key => "navbarcache_id", :force => true do |t|
    t.integer "viewer_id",           :default => 0, :null => false
    t.integer "language_id",         :default => 0, :null => false
    t.text    "navbarcache_cache",                  :null => false
    t.integer "navbarcache_isValid", :default => 0, :null => false
  end

  create_table "navbar_navbargroup", :primary_key => "navbargroup_id", :force => true do |t|
    t.string  "navbargroup_nameKey", :limit => 50, :default => "", :null => false
    t.integer "navbargroup_order",                 :default => 0,  :null => false
  end

  create_table "navbar_navbarlinks", :primary_key => "navbarlink_id", :force => true do |t|
    t.integer  "navbargroup_id",                         :default => 0,                     :null => false
    t.string   "navbarlink_textKey",       :limit => 50, :default => "",                    :null => false
    t.text     "navbarlink_url",                                                            :null => false
    t.integer  "module_id",                              :default => 0,                     :null => false
    t.integer  "navbarlink_isActive",                    :default => 0,                     :null => false
    t.integer  "navbarlink_isModule",                    :default => 0,                     :null => false
    t.integer  "navbarlink_order",                       :default => 0,                     :null => false
    t.datetime "navbarlink_startDateTime",                                                  :null => false
    t.datetime "navbarlink_endDateTime",                 :default => '9999-12-29 23:59:00', :null => false
  end

  create_table "navbar_navlinkaccessgroup", :primary_key => "navlinkaccessgroup_id", :force => true do |t|
    t.integer "navbarlink_id",  :default => 0, :null => false
    t.integer "accessgroup_id", :default => 0, :null => false
  end

  create_table "navbar_navlinkviewer", :primary_key => "navlinkviewer_id", :force => true do |t|
    t.integer "navbarlink_id", :default => 0, :null => false
    t.integer "viewer_id",     :default => 0, :null => false
  end

  create_table "rad_dafield", :primary_key => "dafield_id", :force => true do |t|
    t.integer "daobj_id",                            :default => 0,  :null => false
    t.integer "statevar_id",                         :default => -1, :null => false
    t.string  "dafield_name",          :limit => 50, :default => "", :null => false
    t.text    "dafield_desc",                                        :null => false
    t.string  "dafield_type",          :limit => 50, :default => "", :null => false
    t.string  "dafield_dbType",        :limit => 50, :default => "", :null => false
    t.string  "dafield_formFieldType", :limit => 50, :default => "", :null => false
    t.integer "dafield_isPrimaryKey",                :default => 0,  :null => false
    t.integer "dafield_isForeignKey",                :default => 0,  :null => false
    t.integer "dafield_isNullable",                  :default => 0,  :null => false
    t.string  "dafield_default",       :limit => 50, :default => "", :null => false
    t.string  "dafield_invalidValue",  :limit => 50, :default => "", :null => false
    t.integer "dafield_isLabelName",                 :default => 0,  :null => false
    t.integer "dafield_isListInit",                  :default => 0,  :null => false
    t.integer "dafield_isCreated",                   :default => 0,  :null => false
    t.text    "dafield_title",                                       :null => false
    t.text    "dafield_formLabel",                                   :null => false
    t.text    "dafield_example",                                     :null => false
    t.text    "dafield_error",                                       :null => false
  end

  create_table "rad_daobj", :primary_key => "daobj_id", :force => true do |t|
    t.integer "module_id",                             :default => 0,  :null => false
    t.string  "daobj_name",             :limit => 50,  :default => "", :null => false
    t.text    "daobj_desc",                                            :null => false
    t.string  "daobj_dbTableName",      :limit => 100, :default => "", :null => false
    t.integer "daobj_managerInitVarID",                :default => 0,  :null => false
    t.integer "daobj_listInitVarID",                   :default => 0,  :null => false
    t.integer "daobj_isCreated",                       :default => 0,  :null => false
    t.integer "daobj_isUpdated",                       :default => 0,  :null => false
  end

  create_table "rad_module", :primary_key => "module_id", :force => true do |t|
    t.string  "module_name",         :limit => 50, :default => "", :null => false
    t.text    "module_desc",                                       :null => false
    t.text    "module_creatorName",                                :null => false
    t.integer "module_isCommonLook",               :default => 0,  :null => false
    t.integer "module_isCore",                     :default => 0,  :null => false
    t.integer "module_isCreated",                  :default => 0,  :null => false
  end

  create_table "rad_page", :primary_key => "page_id", :force => true do |t|
    t.integer "module_id",                    :default => 0,  :null => false
    t.string  "page_name",      :limit => 50, :default => "", :null => false
    t.text    "page_desc",                                    :null => false
    t.string  "page_type",      :limit => 5,  :default => "", :null => false
    t.integer "page_isAdd",                   :default => 0,  :null => false
    t.integer "page_rowMgrID",                :default => 0,  :null => false
    t.integer "page_listMgrID",               :default => 0,  :null => false
    t.integer "page_isCreated",               :default => 0,  :null => false
    t.integer "page_isDefault",               :default => 0,  :null => false
  end

  create_table "rad_pagefield", :primary_key => "pagefield_id", :force => true do |t|
    t.integer "page_id",          :default => 0, :null => false
    t.integer "daobj_id",         :default => 0, :null => false
    t.integer "dafield_id",       :default => 0, :null => false
    t.integer "pagefield_isForm", :default => 0, :null => false
  end

  create_table "rad_pagelabels", :primary_key => "pagelabel_id", :force => true do |t|
    t.integer "page_id",                           :default => 0,  :null => false
    t.string  "pagelabel_key",       :limit => 50, :default => "", :null => false
    t.text    "pagelabel_label",                                   :null => false
    t.integer "language_id",                       :default => 0,  :null => false
    t.integer "pagelabel_isCreated",               :default => 0,  :null => false
  end

  create_table "rad_statevar", :primary_key => "statevar_id", :force => true do |t|
    t.integer "module_id",                                                       :default => 0,       :null => false
    t.string  "statevar_name",      :limit => 50,                                :default => "",      :null => false
    t.text    "statevar_desc",                                                                        :null => false
    t.enum    "statevar_type",      :limit => [:STRING, :BOOL, :INTEGER, :DATE], :default => :STRING, :null => false
    t.string  "statevar_default",   :limit => 50,                                :default => "",      :null => false
    t.integer "statevar_isCreated",                                              :default => 0,       :null => false
    t.integer "statevar_isUpdated",                                              :default => 0,       :null => false
  end

  create_table "rad_transitions", :primary_key => "transition_id", :force => true do |t|
    t.integer "module_id",                          :default => 0,  :null => false
    t.integer "transition_fromObjID",               :default => 0,  :null => false
    t.integer "transition_toObjID",                 :default => 0,  :null => false
    t.string  "transition_type",      :limit => 10, :default => "", :null => false
    t.integer "transition_isCreated",               :default => 0,  :null => false
  end

  create_table "site_logmanager", :primary_key => "log_id", :force => true do |t|
    t.string   "log_userID",         :limit => 50, :default => "", :null => false
    t.datetime "log_dateTime",                                     :null => false
    t.string   "log_recipientID",    :limit => 50, :default => "", :null => false
    t.text     "log_description",                                  :null => false
    t.text     "log_data",                                         :null => false
    t.string   "log_viewerIP",       :limit => 15, :default => "", :null => false
    t.string   "log_applicationKey", :limit => 4,  :default => "", :null => false
  end

  create_table "site_multilingual_label", :primary_key => "label_id", :force => true do |t|
    t.integer   "page_id",                     :default => 0,  :null => false
    t.string    "label_key",     :limit => 50, :default => "", :null => false
    t.text      "label_label",                                 :null => false
    t.timestamp "label_moddate",                               :null => false
    t.integer   "language_id",                 :default => 0,  :null => false
  end

  add_index "site_multilingual_label", ["label_key"], :name => "ciministry.site_multilingual_label_label_key_index"
  add_index "site_multilingual_label", ["language_id"], :name => "ciministry.site_multilingual_label_language_id_index"
  add_index "site_multilingual_label", ["page_id"], :name => "ciministry.site_multilingual_label_page_id_index"

  create_table "site_multilingual_page", :primary_key => "page_id", :force => true do |t|
    t.integer "series_id",               :default => 0,  :null => false
    t.string  "page_key",  :limit => 50, :default => "", :null => false
  end

  create_table "site_multilingual_series", :primary_key => "series_id", :force => true do |t|
    t.string "series_key", :limit => 50, :default => "", :null => false
  end

  create_table "site_multilingual_xlation", :primary_key => "xlation_id", :force => true do |t|
    t.integer "label_id",    :default => 0, :null => false
    t.integer "language_id", :default => 0, :null => false
  end

  add_index "site_multilingual_xlation", ["label_id"], :name => "label_id"
  add_index "site_multilingual_xlation", ["language_id"], :name => "language_id"

  create_table "site_page_modules", :primary_key => "module_id", :force => true do |t|
    t.string "module_key",              :limit => 50, :default => "", :null => false
    t.text   "module_path",                                           :null => false
    t.string "module_app",              :limit => 50, :default => "", :null => false
    t.string "module_include",          :limit => 50, :default => "", :null => false
    t.string "module_name",             :limit => 50, :default => "", :null => false
    t.text   "module_parameters",                                     :null => false
    t.string "module_systemAccessFile", :limit => 50, :default => "", :null => false
    t.string "module_systemAccessObj",  :limit => 50, :default => "", :null => false
  end

  create_table "site_session", :primary_key => "session_id", :force => true do |t|
    t.text    "session_data",                      :null => false
    t.integer "session_expiration", :default => 0, :null => false
  end

  create_table "temp_mb_early_frosh", :primary_key => "registration_id", :force => true do |t|
  end

  create_table "wp_comments", :primary_key => "comment_ID", :force => true do |t|
    t.integer  "comment_post_ID",                     :default => 0,   :null => false
    t.text     "comment_author",       :limit => 255,                  :null => false
    t.string   "comment_author_email", :limit => 100, :default => "",  :null => false
    t.string   "comment_author_url",   :limit => 200, :default => "",  :null => false
    t.string   "comment_author_IP",    :limit => 100, :default => "",  :null => false
    t.datetime "comment_date",                                         :null => false
    t.datetime "comment_date_gmt",                                     :null => false
    t.text     "comment_content",                                      :null => false
    t.integer  "comment_karma",                       :default => 0,   :null => false
    t.string   "comment_approved",     :limit => 20,  :default => "1", :null => false
    t.string   "comment_agent",                       :default => "",  :null => false
    t.string   "comment_type",         :limit => 20,  :default => "",  :null => false
    t.integer  "comment_parent",       :limit => 8,   :default => 0,   :null => false
    t.integer  "user_id",              :limit => 8,   :default => 0,   :null => false
  end

  add_index "wp_comments", ["comment_approved", "comment_date_gmt"], :name => "comment_approved_date_gmt"
  add_index "wp_comments", ["comment_approved"], :name => "comment_approved"
  add_index "wp_comments", ["comment_date_gmt"], :name => "comment_date_gmt"
  add_index "wp_comments", ["comment_post_ID"], :name => "comment_post_ID"

  create_table "wp_formbuilder_fields", :force => true do |t|
    t.integer "form_id",       :limit => 8, :null => false
    t.integer "display_order",              :null => false
    t.string  "field_type",                 :null => false
    t.string  "field_name",                 :null => false
    t.binary  "field_value",                :null => false
    t.binary  "field_label",                :null => false
    t.string  "required_data",              :null => false
    t.binary  "error_message",              :null => false
  end

  add_index "wp_formbuilder_fields", ["id"], :name => "id", :unique => true

  create_table "wp_formbuilder_forms", :force => true do |t|
    t.binary  "name",                                  :null => false
    t.binary  "subject",                               :null => false
    t.binary  "recipient",                             :null => false
    t.enum    "method",       :limit => [:POST, :GET], :null => false
    t.string  "action",                                :null => false
    t.binary  "thankyoutext",                          :null => false
    t.integer "autoresponse", :limit => 8,             :null => false
  end

  add_index "wp_formbuilder_forms", ["id"], :name => "id", :unique => true

  create_table "wp_formbuilder_pages", :force => true do |t|
    t.integer "post_id", :limit => 8, :null => false
    t.integer "form_id", :limit => 8, :null => false
  end

  add_index "wp_formbuilder_pages", ["id"], :name => "id", :unique => true

  create_table "wp_formbuilder_responses", :force => true do |t|
    t.binary "name",       :null => false
    t.binary "subject",    :null => false
    t.binary "message",    :null => false
    t.binary "from_name",  :null => false
    t.string "from_email", :null => false
  end

  create_table "wp_links", :primary_key => "link_id", :force => true do |t|
    t.string   "link_url",                             :default => "",  :null => false
    t.string   "link_name",                            :default => "",  :null => false
    t.string   "link_image",                           :default => "",  :null => false
    t.string   "link_target",      :limit => 25,       :default => "",  :null => false
    t.integer  "link_category",    :limit => 8,        :default => 0,   :null => false
    t.string   "link_description",                     :default => "",  :null => false
    t.string   "link_visible",     :limit => 20,       :default => "Y", :null => false
    t.integer  "link_owner",                           :default => 1,   :null => false
    t.integer  "link_rating",                          :default => 0,   :null => false
    t.datetime "link_updated",                                          :null => false
    t.string   "link_rel",                             :default => "",  :null => false
    t.text     "link_notes",       :limit => 16777215,                  :null => false
    t.string   "link_rss",                             :default => "",  :null => false
  end

  add_index "wp_links", ["link_category"], :name => "link_category"
  add_index "wp_links", ["link_visible"], :name => "link_visible"

  create_table "wp_options", :id => false, :force => true do |t|
    t.integer "option_id",    :limit => 8,                             :null => false
    t.integer "blog_id",                            :default => 0,     :null => false
    t.string  "option_name",  :limit => 64,         :default => "",    :null => false
    t.text    "option_value", :limit => 2147483647,                    :null => false
    t.string  "autoload",     :limit => 20,         :default => "yes", :null => false
  end

  add_index "wp_options", ["option_name"], :name => "option_name"

  create_table "wp_postmeta", :primary_key => "meta_id", :force => true do |t|
    t.integer "post_id",    :limit => 8,          :default => 0, :null => false
    t.string  "meta_key"
    t.text    "meta_value", :limit => 2147483647
  end

  add_index "wp_postmeta", ["meta_key"], :name => "meta_key"
  add_index "wp_postmeta", ["post_id"], :name => "post_id"

  create_table "wp_posts", :primary_key => "ID", :force => true do |t|
    t.integer  "post_author",           :limit => 8,          :default => 0,         :null => false
    t.datetime "post_date",                                                          :null => false
    t.datetime "post_date_gmt",                                                      :null => false
    t.text     "post_content",          :limit => 2147483647,                        :null => false
    t.text     "post_title",                                                         :null => false
    t.integer  "post_category",                               :default => 0,         :null => false
    t.text     "post_excerpt",                                                       :null => false
    t.string   "post_status",           :limit => 20,         :default => "publish", :null => false
    t.string   "comment_status",        :limit => 20,         :default => "open",    :null => false
    t.string   "ping_status",           :limit => 20,         :default => "open",    :null => false
    t.string   "post_password",         :limit => 20,         :default => "",        :null => false
    t.string   "post_name",             :limit => 200,        :default => "",        :null => false
    t.text     "to_ping",                                                            :null => false
    t.text     "pinged",                                                             :null => false
    t.datetime "post_modified",                                                      :null => false
    t.datetime "post_modified_gmt",                                                  :null => false
    t.text     "post_content_filtered",                                              :null => false
    t.integer  "post_parent",           :limit => 8,          :default => 0,         :null => false
    t.string   "guid",                                        :default => "",        :null => false
    t.integer  "menu_order",                                  :default => 0,         :null => false
    t.string   "post_type",             :limit => 20,         :default => "post",    :null => false
    t.string   "post_mime_type",        :limit => 100,        :default => "",        :null => false
    t.integer  "comment_count",         :limit => 8,          :default => 0,         :null => false
  end

  add_index "wp_posts", ["post_name"], :name => "post_name"
  add_index "wp_posts", ["post_parent"], :name => "post_parent"
  add_index "wp_posts", ["post_type", "post_status", "post_date", "ID"], :name => "type_status_date"

  create_table "wp_term_relationships", :id => false, :force => true do |t|
    t.integer "object_id",        :limit => 8, :default => 0, :null => false
    t.integer "term_taxonomy_id", :limit => 8, :default => 0, :null => false
    t.integer "term_order",                    :default => 0, :null => false
  end

  add_index "wp_term_relationships", ["term_taxonomy_id"], :name => "term_taxonomy_id"

  create_table "wp_term_taxonomy", :primary_key => "term_taxonomy_id", :force => true do |t|
    t.integer "term_id",     :limit => 8,          :default => 0,  :null => false
    t.string  "taxonomy",    :limit => 32,         :default => "", :null => false
    t.text    "description", :limit => 2147483647,                 :null => false
    t.integer "parent",      :limit => 8,          :default => 0,  :null => false
    t.integer "count",       :limit => 8,          :default => 0,  :null => false
  end

  add_index "wp_term_taxonomy", ["term_id", "taxonomy"], :name => "term_id_taxonomy", :unique => true

  create_table "wp_terms", :primary_key => "term_id", :force => true do |t|
    t.string  "name",       :limit => 200, :default => "", :null => false
    t.string  "slug",       :limit => 200, :default => "", :null => false
    t.integer "term_group", :limit => 8,   :default => 0,  :null => false
  end

  add_index "wp_terms", ["name"], :name => "name"
  add_index "wp_terms", ["slug"], :name => "slug", :unique => true

  create_table "wp_usermeta", :primary_key => "umeta_id", :force => true do |t|
    t.integer "user_id",    :limit => 8,          :default => 0, :null => false
    t.string  "meta_key"
    t.text    "meta_value", :limit => 2147483647
  end

  add_index "wp_usermeta", ["meta_key"], :name => "meta_key"
  add_index "wp_usermeta", ["user_id"], :name => "user_id"

  create_table "wp_users", :primary_key => "ID", :force => true do |t|
    t.string   "user_login",          :limit => 60,  :default => "", :null => false
    t.string   "user_pass",           :limit => 64,  :default => "", :null => false
    t.string   "user_nicename",       :limit => 50,  :default => "", :null => false
    t.string   "user_email",          :limit => 100, :default => "", :null => false
    t.string   "user_url",            :limit => 100, :default => "", :null => false
    t.datetime "user_registered",                                    :null => false
    t.string   "user_activation_key", :limit => 60,  :default => "", :null => false
    t.integer  "user_status",                        :default => 0,  :null => false
    t.string   "display_name",        :limit => 250, :default => "", :null => false
  end

  add_index "wp_users", ["user_login"], :name => "user_login_key"
  add_index "wp_users", ["user_nicename"], :name => "user_nicename"

end
