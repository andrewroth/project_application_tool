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

  create_table "08_staff_survey", :primary_key => "survey_id", :force => true do |t|
    t.string "survey_name",  :limit => 128, :default => "", :null => false
    t.string "survey_email", :limit => 128, :default => "", :null => false
  end

  create_table "accountadmin_accesscategory", :primary_key => "accesscategory_id", :force => true do |t|
    t.string "accesscategory_key", :limit => 50, :default => "", :null => false
  end

  add_index "accountadmin_accesscategory", ["accesscategory_key"], :name => "ciministry.accountadmin_accesscategory_accesscateg"

  create_table "accountadmin_accessgroup", :primary_key => "accessgroup_id", :force => true do |t|
    t.integer "accesscategory_id",               :default => 0,  :null => false
    t.string  "accessgroup_key",   :limit => 50, :default => "", :null => false
  end

  add_index "accountadmin_accessgroup", ["accessgroup_key"], :name => "ciministry.accountadmin_accessgroup_accessgroup_ke"

  create_table "accountadmin_accountadminaccess", :primary_key => "accountadminaccess_id", :force => true do |t|
    t.integer "viewer_id",                                 :default => 0, :null => false
    t.integer "accountadminaccess_privilege", :limit => 1, :default => 0, :null => false
  end

  add_index "accountadmin_accountadminaccess", ["viewer_id"], :name => "ciministry.accountadmin_accountadminaccess_viewer_"
  add_index "accountadmin_accountadminaccess", ["accountadminaccess_privilege"], :name => "ciministry.accountadmin_accountadminaccess_account"

  create_table "accountadmin_accountgroup", :primary_key => "accountgroup_id", :force => true do |t|
    t.string "accountgroup_key",        :limit => 50, :default => "", :null => false
    t.string "accountgroup_label_long", :limit => 50, :default => "", :null => false
  end

  create_table "accountadmin_language", :primary_key => "language_id", :force => true do |t|
    t.string "language_key",  :limit => 25, :default => "", :null => false
    t.string "language_code", :limit => 2,  :default => "", :null => false
  end

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

  create_table "aia_greycup", :primary_key => "registration_id", :force => true do |t|
    t.integer "num_tickets", :limit => 5, :default => 0, :null => false
    t.integer "to_survey",   :limit => 1, :default => 0, :null => false
  end

  create_table "cim_c4cwebsite_page", :primary_key => "page_id", :force => true do |t|
    t.integer "page_parentID",        :limit => 8,   :default => 0,  :null => false
    t.string  "page_breadcrumbTitle", :limit => 64,  :default => "", :null => false
    t.string  "page_templateName",    :limit => 128, :default => "", :null => false
    t.string  "page_link",            :limit => 128, :default => "", :null => false
    t.integer "page_order",           :limit => 8,   :default => 0,  :null => false
    t.text    "page_keywords",                       :default => "", :null => false
  end

  create_table "cim_c4cwebsite_projects", :primary_key => "projects_id", :force => true do |t|
    t.string "projects_desc",   :limit => 50,  :default => "", :null => false
    t.string "project_website", :limit => 200
    t.string "project_name",    :limit => 50
  end

  create_table "cim_downhere", :primary_key => "dh_id", :force => true do |t|
    t.string  "cctransaction_cardName",  :limit => 64,  :default => "", :null => false
    t.integer "cctype_id",               :limit => 16,  :default => 0,  :null => false
    t.string  "cctransaction_cardNum",   :limit => 64,  :default => "", :null => false
    t.string  "cctransaction_expiry",    :limit => 64,  :default => "", :null => false
    t.string  "cctransaction_billingPC", :limit => 64,  :default => "", :null => false
    t.integer "cctransaction_processed", :limit => 16,  :default => 0,  :null => false
    t.string  "dh_name",                 :limit => 128, :default => "", :null => false
    t.string  "dh_email",                :limit => 128, :default => "", :null => false
    t.string  "dh_phone",                :limit => 128, :default => "", :null => false
    t.integer "dh_numTickets",           :limit => 16,  :default => 0,  :null => false
    t.string  "dh_church",               :limit => 128, :default => "", :null => false
  end

  create_table "cim_hrdb_access", :primary_key => "access_id", :force => true do |t|
    t.integer "viewer_id", :limit => 50, :default => 0, :null => false
    t.integer "person_id", :limit => 50, :default => 0, :null => false
  end

  add_index "cim_hrdb_access", ["viewer_id"], :name => "ciministry.cim_hrdb_access_viewer_id_index"
  add_index "cim_hrdb_access", ["person_id"], :name => "ciministry.cim_hrdb_access_person_id_index"

  create_table "cim_hrdb_activityschedule", :primary_key => "activityschedule_id", :force => true do |t|
    t.integer "staffactivity_id", :limit => 15, :default => 0, :null => false
    t.integer "staffschedule_id", :limit => 15, :default => 0, :null => false
  end

  add_index "cim_hrdb_activityschedule", ["staffschedule_id"], :name => "FK_activity_schedule"
  add_index "cim_hrdb_activityschedule", ["staffactivity_id"], :name => "FK_schedule_activity"

  create_table "cim_hrdb_activitytype", :primary_key => "activitytype_id", :force => true do |t|
    t.string "activitytype_desc",  :limit => 75, :default => "",        :null => false
    t.string "activitytype_abbr",  :limit => 6,  :default => "",        :null => false
    t.string "activitytype_color", :limit => 7,  :default => "#0000FF", :null => false
  end

  create_table "cim_hrdb_admin", :primary_key => "admin_id", :force => true do |t|
    t.integer "person_id", :limit => 50, :default => 0, :null => false
    t.integer "priv_id",   :limit => 20, :default => 0, :null => false
  end

  add_index "cim_hrdb_admin", ["person_id"], :name => "FK_hrdbadmin_person"
  add_index "cim_hrdb_admin", ["priv_id"], :name => "FK_admin_priv"

  create_table "cim_hrdb_assignment", :primary_key => "assignment_id", :force => true do |t|
    t.integer "person_id",           :limit => 50, :default => 0, :null => false
    t.integer "campus_id",           :limit => 50, :default => 0, :null => false
    t.integer "assignmentstatus_id", :limit => 10, :default => 0, :null => false
  end

  add_index "cim_hrdb_assignment", ["person_id"], :name => "ciministry.cim_hrdb_assignment_person_id_index"
  add_index "cim_hrdb_assignment", ["campus_id"], :name => "ciministry.cim_hrdb_assignment_campus_id_index"

  create_table "cim_hrdb_assignmentstatus", :primary_key => "assignmentstatus_id", :force => true do |t|
    t.string "assignmentstatus_desc", :limit => 64, :default => "", :null => false
  end

  create_table "cim_hrdb_campus", :primary_key => "campus_id", :force => true do |t|
    t.string  "campus_desc",      :limit => 128, :default => "", :null => false
    t.string  "campus_shortDesc", :limit => 50,  :default => "", :null => false
    t.integer "accountgroup_id",  :limit => 16,  :default => 0,  :null => false
    t.integer "region_id",        :limit => 8,   :default => 0,  :null => false
    t.string  "campus_website",   :limit => 128, :default => "", :null => false
  end

  add_index "cim_hrdb_campus", ["region_id"], :name => "ciministry.cim_hrdb_campus_region_id_index"
  add_index "cim_hrdb_campus", ["accountgroup_id"], :name => "ciministry.cim_hrdb_campus_accountgroup_id_index"

  create_table "cim_hrdb_campusadmin", :primary_key => "campusadmin_id", :force => true do |t|
    t.integer "admin_id",  :limit => 20, :default => 0, :null => false
    t.integer "campus_id", :limit => 20, :default => 0, :null => false
  end

  add_index "cim_hrdb_campusadmin", ["admin_id"], :name => "ciministry.cim_hrdb_campusadmin_admin_id_index"
  add_index "cim_hrdb_campusadmin", ["campus_id"], :name => "ciministry.cim_hrdb_campusadmin_campus_id_index"

  create_table "cim_hrdb_country", :primary_key => "country_id", :force => true do |t|
    t.string "country_desc",      :limit => 50, :default => "", :null => false
    t.string "country_shortDesc", :limit => 50, :default => "", :null => false
  end

  create_table "cim_hrdb_customfields", :primary_key => "customfields_id", :force => true do |t|
    t.integer "report_id", :limit => 10, :null => false
    t.integer "fields_id", :limit => 16, :null => false
  end

  add_index "cim_hrdb_customfields", ["report_id"], :name => "FK_fields_report"
  add_index "cim_hrdb_customfields", ["fields_id"], :name => "FK_report_field"

  create_table "cim_hrdb_customreports", :primary_key => "report_id", :force => true do |t|
    t.string "report_name", :limit => 64, :default => "", :null => false
  end

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

  create_table "cim_hrdb_fieldgroup", :primary_key => "fieldgroup_id", :force => true do |t|
    t.string "fieldgroup_desc", :limit => 75, :default => "", :null => false
  end

  create_table "cim_hrdb_fieldgroup_matches", :primary_key => "fieldgroup_matches_id", :force => true do |t|
    t.integer "fieldgroup_id", :limit => 10, :default => 0, :null => false
    t.integer "fields_id",     :limit => 16, :default => 0, :null => false
  end

  create_table "cim_hrdb_fields", :primary_key => "fields_id", :force => true do |t|
    t.integer "fieldtype_id",         :limit => 16,  :default => 0,  :null => false
    t.text    "fields_desc",                         :default => "", :null => false
    t.integer "staffscheduletype_id", :limit => 15,  :default => 0,  :null => false
    t.integer "fields_priority",      :limit => 16,  :default => 0,  :null => false
    t.integer "fields_reqd",          :limit => 8,   :default => 0,  :null => false
    t.string  "fields_invalid",       :limit => 128, :default => "", :null => false
    t.integer "fields_hidden",        :limit => 8,   :default => 0,  :null => false
    t.integer "datatypes_id",         :limit => 4,   :default => 0,  :null => false
    t.integer "fieldgroup_id",        :limit => 10,  :default => 0,  :null => false
    t.string  "fields_note",          :limit => 75,  :default => "", :null => false
  end

  add_index "cim_hrdb_fields", ["fieldtype_id"], :name => "FK_fields_types2"
  add_index "cim_hrdb_fields", ["staffscheduletype_id"], :name => "FK_fields_form"
  add_index "cim_hrdb_fields", ["datatypes_id"], :name => "FK_fields_dtype2"

  create_table "cim_hrdb_fieldvalues", :primary_key => "fieldvalues_id", :force => true do |t|
    t.integer   "fields_id",           :limit => 16, :default => 0,  :null => false
    t.text      "fieldvalues_value",                 :default => "", :null => false
    t.integer   "person_id",           :limit => 16, :default => 0,  :null => false
    t.timestamp "fieldvalues_modTime",                               :null => false
  end

  add_index "cim_hrdb_fieldvalues", ["person_id"], :name => "FK_fieldvals_person"
  add_index "cim_hrdb_fieldvalues", ["fields_id"], :name => "FK_fieldvals_field2"

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

  create_table "cim_hrdb_person_year", :primary_key => "personyear_id", :force => true do |t|
    t.integer "person_id", :limit => 50, :default => 0, :null => false
    t.integer "year_id",   :limit => 50, :default => 0, :null => false
    t.date    "grad_date",                              :null => false
  end

  add_index "cim_hrdb_person_year", ["person_id"], :name => "FK_cim_hrdb_person_year"
  add_index "cim_hrdb_person_year", ["year_id"], :name => "1"

  create_table "cim_hrdb_priv", :primary_key => "priv_id", :force => true do |t|
    t.string "priv_accesslevel", :limit => 100, :default => "", :null => false
  end

  create_table "cim_hrdb_province", :primary_key => "province_id", :force => true do |t|
    t.string "province_desc",      :limit => 50, :default => "", :null => false
    t.string "province_shortDesc", :limit => 50, :default => "", :null => false
  end

  create_table "cim_hrdb_region", :primary_key => "region_id", :force => true do |t|
    t.string  "reg_desc",   :limit => 64, :default => "", :null => false
    t.integer "country_id", :limit => 50, :default => 0,  :null => false
  end

  add_index "cim_hrdb_region", ["country_id"], :name => "FK_region_country"

  create_table "cim_hrdb_staff", :primary_key => "staff_id", :force => true do |t|
    t.integer "person_id", :limit => 50, :default => 0, :null => false
    t.integer "is_active", :limit => 1,  :default => 1, :null => false
  end

  add_index "cim_hrdb_staff", ["person_id"], :name => "ciministry.cim_hrdb_staff_person_id_index"

  create_table "cim_hrdb_staffactivity", :primary_key => "staffactivity_id", :force => true do |t|
    t.integer "person_id",                  :limit => 50, :default => 0,  :null => false
    t.date    "staffactivity_startdate",                                  :null => false
    t.date    "staffactivity_enddate",                                    :null => false
    t.string  "staffactivity_contactPhone", :limit => 20, :default => "", :null => false
    t.integer "activitytype_id",            :limit => 10, :default => 0,  :null => false
  end

  add_index "cim_hrdb_staffactivity", ["activitytype_id"], :name => "FK_activity_type"
  add_index "cim_hrdb_staffactivity", ["person_id"], :name => "FK_activity_person"

  create_table "cim_hrdb_staffdirector", :primary_key => "staffdirector_id", :force => true do |t|
    t.integer "staff_id",    :limit => 50, :null => false
    t.integer "director_id", :limit => 50, :null => false
  end

  add_index "cim_hrdb_staffdirector", ["director_id"], :name => "FK_director_staff"
  add_index "cim_hrdb_staffdirector", ["staff_id"], :name => "FK_staff_staff1"

  create_table "cim_hrdb_staffschedule", :primary_key => "staffschedule_id", :force => true do |t|
    t.integer   "person_id",                            :limit => 50, :default => 0,  :null => false
    t.integer   "staffscheduletype_id",                 :limit => 15, :default => 0,  :null => false
    t.integer   "staffschedule_approved",               :limit => 2,  :default => 0,  :null => false
    t.integer   "staffschedule_approvedby",             :limit => 50, :default => 0,  :null => false
    t.timestamp "staffschedule_lastmodifiedbydirector",                               :null => false
    t.text      "staffschedule_approvalnotes",                        :default => "", :null => false
    t.integer   "staffschedule_tonotify",               :limit => 2,  :default => 0,  :null => false
  end

  add_index "cim_hrdb_staffschedule", ["staffscheduletype_id"], :name => "FK_schedule_type"
  add_index "cim_hrdb_staffschedule", ["person_id"], :name => "FK_schedule_person1"

  create_table "cim_hrdb_staffscheduleinstr", :primary_key => "staffscheduletype_id", :force => true do |t|
    t.text "staffscheduleinstr_toptext",    :default => "", :null => false
    t.text "staffscheduleinstr_bottomtext", :default => "", :null => false
  end

  create_table "cim_hrdb_staffscheduletype", :primary_key => "staffscheduletype_id", :force => true do |t|
    t.string  "staffscheduletype_desc",               :limit => 75, :default => "", :null => false
    t.date    "staffscheduletype_startdate",                                        :null => false
    t.date    "staffscheduletype_enddate",                                          :null => false
    t.integer "staffscheduletype_has_activities",     :limit => 2,  :default => 1,  :null => false
    t.integer "staffscheduletype_has_activity_phone", :limit => 2,  :default => 0,  :null => false
    t.string  "staffscheduletype_activity_types",     :limit => 25, :default => "", :null => false
    t.integer "staffscheduletype_is_shown",           :limit => 2,  :default => 0,  :null => false
  end

  create_table "cim_hrdb_year_in_school", :primary_key => "year_id", :force => true do |t|
    t.string "year_desc", :limit => 50, :default => "", :null => false
  end

  create_table "cim_reg_activerules", :primary_key => "pricerules_id", :force => true do |t|
    t.integer "is_active",       :limit => 1, :default => 0, :null => false
    t.integer "is_recalculated", :limit => 1, :default => 1, :null => false
  end

  create_table "cim_reg_campusaccess", :primary_key => "campusaccess_id", :force => true do |t|
    t.integer "eventadmin_id", :limit => 16, :default => 0, :null => false
    t.integer "campus_id",     :limit => 16, :default => 0, :null => false
  end

  create_table "cim_reg_cashtransaction", :primary_key => "cashtransaction_id", :force => true do |t|
    t.integer   "reg_id",                    :limit => 16, :default => 0,   :null => false
    t.string    "cashtransaction_staffName", :limit => 64, :default => "",  :null => false
    t.integer   "cashtransaction_recd",      :limit => 8,  :default => 0,   :null => false
    t.float     "cashtransaction_amtPaid",                 :default => 0.0, :null => false
    t.timestamp "cashtransaction_moddate",                                  :null => false
  end

  add_index "cim_reg_cashtransaction", ["reg_id"], :name => "FK_cashtrans_reg"

  create_table "cim_reg_ccreceipt", :primary_key => "cctransaction_id", :force => true do |t|
    t.string    "ccreceipt_sequencenum",  :limit => 18,  :default => "", :null => false
    t.string    "ccreceipt_authcode",     :limit => 8
    t.string    "ccreceipt_responsecode", :limit => 3,   :default => "", :null => false
    t.string    "ccreceipt_message",      :limit => 100, :default => "", :null => false
    t.timestamp "ccreceipt_moddate",                                     :null => false
  end

  create_table "cim_reg_cctransaction", :primary_key => "cctransaction_id", :force => true do |t|
    t.integer   "reg_id",                  :limit => 16, :default => 0,   :null => false
    t.string    "cctransaction_cardName",  :limit => 64, :default => "",  :null => false
    t.integer   "cctype_id",               :limit => 16, :default => 0,   :null => false
    t.text      "cctransaction_cardNum",                 :default => "",  :null => false
    t.string    "cctransaction_expiry",    :limit => 64, :default => "",  :null => false
    t.string    "cctransaction_billingPC", :limit => 64, :default => "",  :null => false
    t.integer   "cctransaction_processed", :limit => 16, :default => 0,   :null => false
    t.float     "cctransaction_amount",                  :default => 0.0, :null => false
    t.timestamp "cctransaction_moddate",                                  :null => false
    t.string    "cctransaction_refnum"
  end

  add_index "cim_reg_cctransaction", ["reg_id"], :name => "FK_cctrans_reg"
  add_index "cim_reg_cctransaction", ["cctype_id"], :name => "FK_cctrans_ccid"

  create_table "cim_reg_cctype", :primary_key => "cctype_id", :force => true do |t|
    t.string "cctype_desc", :limit => 32, :default => "", :null => false
  end

  create_table "cim_reg_datatypes", :primary_key => "datatypes_id", :force => true do |t|
    t.string "datatypes_key",  :limit => 8,  :default => "", :null => false
    t.string "datatypes_desc", :limit => 64, :default => "", :null => false
  end

  create_table "cim_reg_event", :primary_key => "event_id", :force => true do |t|
    t.integer  "country_id",             :limit => 50,  :default => 0,   :null => false
    t.string   "event_name",             :limit => 128, :default => "",  :null => false
    t.string   "event_descBrief",        :limit => 128, :default => "",  :null => false
    t.text     "event_descDetail",                      :default => "",  :null => false
    t.datetime "event_startDate",                                        :null => false
    t.datetime "event_endDate",                                          :null => false
    t.datetime "event_regStart",                                         :null => false
    t.datetime "event_regEnd",                                           :null => false
    t.string   "event_website",          :limit => 128, :default => "",  :null => false
    t.text     "event_emailConfirmText",                :default => "",  :null => false
    t.float    "event_basePrice",                       :default => 0.0, :null => false
    t.float    "event_deposit",                         :default => 0.0, :null => false
    t.text     "event_contactEmail",                    :default => "",  :null => false
    t.text     "event_pricingText",                     :default => "",  :null => false
    t.integer  "event_onHomePage",       :limit => 1,   :default => 1,   :null => false
    t.integer  "event_allowCash",        :limit => 1,   :default => 1,   :null => false
  end

  create_table "cim_reg_eventadmin", :primary_key => "eventadmin_id", :force => true do |t|
    t.integer "event_id",  :limit => 16, :default => 0, :null => false
    t.integer "priv_id",   :limit => 16, :default => 0, :null => false
    t.integer "viewer_id", :limit => 16, :default => 0, :null => false
  end

  add_index "cim_reg_eventadmin", ["event_id"], :name => "FK_admin_event"
  add_index "cim_reg_eventadmin", ["viewer_id"], :name => "FK_admin_viewer"
  add_index "cim_reg_eventadmin", ["priv_id"], :name => "FK_evadmin_priv"

  create_table "cim_reg_fields", :primary_key => "fields_id", :force => true do |t|
    t.integer "fieldtype_id",    :limit => 16,  :default => 0,  :null => false
    t.text    "fields_desc",                    :default => "", :null => false
    t.integer "event_id",        :limit => 16,  :default => 0,  :null => false
    t.integer "fields_priority", :limit => 16,  :default => 0,  :null => false
    t.integer "fields_reqd",     :limit => 8,   :default => 0,  :null => false
    t.string  "fields_invalid",  :limit => 128, :default => "", :null => false
    t.integer "fields_hidden",   :limit => 8,   :default => 0,  :null => false
    t.integer "datatypes_id",    :limit => 4,   :default => 0,  :null => false
  end

  add_index "cim_reg_fields", ["fieldtype_id"], :name => "FK_fields_types"
  add_index "cim_reg_fields", ["event_id"], :name => "FK_fields_event"
  add_index "cim_reg_fields", ["datatypes_id"], :name => "FK_fields_dtype"

  create_table "cim_reg_fieldtypes", :primary_key => "fieldtypes_id", :force => true do |t|
    t.string "fieldtypes_desc", :limit => 128, :default => "", :null => false
  end

  create_table "cim_reg_fieldvalues", :primary_key => "fieldvalues_id", :force => true do |t|
    t.integer   "fields_id",           :limit => 16, :default => 0,  :null => false
    t.text      "fieldvalues_value",                 :default => "", :null => false
    t.integer   "registration_id",     :limit => 16, :default => 0,  :null => false
    t.timestamp "fieldvalues_modTime",                               :null => false
  end

  add_index "cim_reg_fieldvalues", ["registration_id"], :name => "FK_fieldvals_reg"
  add_index "cim_reg_fieldvalues", ["fields_id"], :name => "FK_fieldvals_field"

  create_table "cim_reg_pricerules", :primary_key => "pricerules_id", :force => true do |t|
    t.integer "event_id",            :limit => 16,  :default => 0,   :null => false
    t.integer "priceruletypes_id",   :limit => 16,  :default => 0,   :null => false
    t.text    "pricerules_desc",                    :default => "",  :null => false
    t.integer "fields_id",           :limit => 10,  :default => 0,   :null => false
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
    t.integer  "event_id",                :limit => 50, :default => 0,   :null => false
    t.integer  "person_id",               :limit => 50, :default => 0,   :null => false
    t.datetime "registration_date",                                      :null => false
    t.string   "registration_confirmNum", :limit => 64, :default => "",  :null => false
    t.integer  "registration_status",     :limit => 2,  :default => 0,   :null => false
    t.float    "registration_balance",                  :default => 0.0, :null => false
  end

  add_index "cim_reg_registration", ["person_id"], :name => "FK_reg_person"
  add_index "cim_reg_registration", ["registration_status"], :name => "FK_reg_status"

  create_table "cim_reg_scholarship", :primary_key => "scholarship_id", :force => true do |t|
    t.integer "registration_id",        :limit => 16,  :default => 0,   :null => false
    t.float   "scholarship_amount",                    :default => 0.0, :null => false
    t.string  "scholarship_sourceAcct", :limit => 64,  :default => "",  :null => false
    t.string  "scholarship_sourceDesc", :limit => 128, :default => "",  :null => false
  end

  add_index "cim_reg_scholarship", ["registration_id"], :name => "FK_scholarship_reg"

  create_table "cim_reg_status", :primary_key => "status_id", :force => true do |t|
    t.string "status_desc", :limit => 32, :default => "", :null => false
  end

  create_table "cim_reg_superadmin", :primary_key => "superadmin_id", :force => true do |t|
    t.integer "viewer_id", :limit => 16, :default => 0, :null => false
  end

  add_index "cim_reg_superadmin", ["viewer_id"], :name => "FK_viewer_regsuperadmin"

  create_table "cim_sch_campusGroup", :primary_key => "campusGroup_id", :force => true do |t|
    t.integer "group_id"
    t.integer "campus_id"
  end

  add_index "cim_sch_campusGroup", ["group_id"], :name => "FK_campus_group"
  add_index "cim_sch_campusGroup", ["campus_id"], :name => "FK_group_campus"

  create_table "cim_sch_group", :primary_key => "group_id", :force => true do |t|
    t.integer "groupType_id"
    t.string  "group_name",   :limit => 20, :default => "", :null => false
    t.string  "group_desc",                 :default => "", :null => false
  end

  add_index "cim_sch_group", ["groupType_id"], :name => "FK_group_type"

  create_table "cim_sch_groupAssociation", :primary_key => "groupAssocation_id", :force => true do |t|
    t.integer "group_id"
    t.integer "person_id"
  end

  add_index "cim_sch_groupAssociation", ["group_id"], :name => "FK_person_group"
  add_index "cim_sch_groupAssociation", ["person_id"], :name => "FK_group_person"

  create_table "cim_sch_groupType", :primary_key => "groupType_id", :force => true do |t|
    t.string "groupType_desc", :limit => 20
  end

  create_table "cim_sch_permissionsCampusAdmin", :primary_key => "permissionsCampusAdmin_id", :force => true do |t|
    t.integer "viewer_id"
    t.integer "campus_id"
  end

  add_index "cim_sch_permissionsCampusAdmin", ["viewer_id"], :name => "FK_schcampusadmin_viewer"
  add_index "cim_sch_permissionsCampusAdmin", ["campus_id"], :name => "FK_schcampusadmin_campus"

  create_table "cim_sch_permissionsGroupAdmin", :primary_key => "permissionsGroupAdmin_id", :force => true do |t|
    t.integer "viewer_id"
    t.integer "group_id"
    t.integer "permissionsGroupAdmin_emailNotification", :default => 1
  end

  add_index "cim_sch_permissionsGroupAdmin", ["viewer_id"], :name => "FK_schgroupadmin_viewer"
  add_index "cim_sch_permissionsGroupAdmin", ["group_id"], :name => "FK_schgroupadmin_group"

  create_table "cim_sch_permissionsSuperAdmin", :primary_key => "permissionsSuperAdmin_id", :force => true do |t|
    t.integer "viewer_id"
  end

  add_index "cim_sch_permissionsSuperAdmin", ["viewer_id"], :name => "FK_schsuperadmin_viewer"

  create_table "cim_sch_schedule", :primary_key => "schedule_id", :force => true do |t|
    t.integer  "person_id"
    t.integer  "timezones_id"
    t.datetime "schedule_dateTimeStamp", :null => false
  end

  add_index "cim_sch_schedule", ["person_id"], :name => "FK_sched_person"
  add_index "cim_sch_schedule", ["timezones_id"], :name => "FK_sched_tzone"

  create_table "cim_sch_scheduleBlocks", :primary_key => "scheduleBlocks_id", :force => true do |t|
    t.integer "schedule_id"
    t.integer "scheduleBlocks_timeblock"
  end

  add_index "cim_sch_scheduleBlocks", ["schedule_id"], :name => "FK_schblock_sched"

  create_table "cim_sch_timezones", :primary_key => "timezones_id", :force => true do |t|
    t.string  "timezones_desc",   :limit => 32
    t.integer "timezones_offset"
  end

  create_table "cim_stats_access", :primary_key => "access_id", :force => true do |t|
    t.integer "staff_id", :limit => 16, :default => 0, :null => false
    t.integer "priv_id",  :limit => 16, :default => 0, :null => false
  end

  create_table "cim_stats_coordinator", :primary_key => "coordinator_id", :force => true do |t|
    t.integer "access_id", :limit => 16, :default => 0, :null => false
    t.integer "campus_id", :limit => 16, :default => 0, :null => false
  end

  create_table "cim_stats_exposuretype", :primary_key => "exposuretype_id", :force => true do |t|
    t.string "exposuretype_desc", :limit => 64, :default => "", :null => false
  end

  create_table "cim_stats_morestats", :primary_key => "morestats_id", :force => true do |t|
    t.integer "morestats_exp",   :limit => 10, :default => 0,  :null => false
    t.text    "morestats_notes",               :default => "", :null => false
    t.integer "week_id",         :limit => 10, :default => 0,  :null => false
    t.integer "campus_id",       :limit => 10, :default => 0,  :null => false
    t.integer "exposuretype_id", :limit => 10, :default => 0,  :null => false
  end

  create_table "cim_stats_prc", :primary_key => "prc_id", :force => true do |t|
    t.string  "prc_firstName",    :limit => 128, :default => "", :null => false
    t.integer "prcMethod_id",     :limit => 10,  :default => 0,  :null => false
    t.string  "prc_witnessName",  :limit => 128, :default => "", :null => false
    t.integer "semester_id",      :limit => 10,  :default => 0,  :null => false
    t.integer "campus_id",        :limit => 10,  :default => 0,  :null => false
    t.text    "prc_notes",                       :default => "", :null => false
    t.integer "prc_7upCompleted", :limit => 10,  :default => 0,  :null => false
    t.integer "prc_7upStarted",   :limit => 10,  :default => 0,  :null => false
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
    t.integer "year_id",            :limit => 8,  :default => 0,  :null => false
  end

  create_table "cim_stats_semesterreport", :primary_key => "semesterreport_id", :force => true do |t|
    t.integer "semesterreport_avgPrayer",        :limit => 10, :default => 0, :null => false
    t.integer "semesterreport_avgWklyMtg",       :limit => 10, :default => 0, :null => false
    t.integer "semesterreport_numStaffChall",    :limit => 10, :default => 0, :null => false
    t.integer "semesterreport_numInternChall",   :limit => 10, :default => 0, :null => false
    t.integer "semesterreport_numFrosh",         :limit => 10, :default => 0, :null => false
    t.integer "semesterreport_numStaffDG",       :limit => 10, :default => 0, :null => false
    t.integer "semesterreport_numInStaffDG",     :limit => 10, :default => 0, :null => false
    t.integer "semesterreport_numStudentDG",     :limit => 10, :default => 0, :null => false
    t.integer "semesterreport_numInStudentDG",   :limit => 10, :default => 0, :null => false
    t.integer "semesterreport_numSpMultStaffDG", :limit => 10, :default => 0, :null => false
    t.integer "semesterreport_numSpMultStdDG",   :limit => 10, :default => 0, :null => false
    t.integer "semester_id",                     :limit => 10, :default => 0, :null => false
    t.integer "campus_id",                       :limit => 10, :default => 0, :null => false
  end

  create_table "cim_stats_week", :primary_key => "week_id", :force => true do |t|
    t.date    "week_endDate",                              :null => false
    t.integer "semester_id",  :limit => 16, :default => 0, :null => false
  end

  create_table "cim_stats_weeklyreport", :primary_key => "weeklyReport_id", :force => true do |t|
    t.integer "weeklyReport_1on1SpConv",      :limit => 10, :default => 0,  :null => false
    t.integer "weeklyReport_1on1GosPres",     :limit => 10, :default => 0,  :null => false
    t.integer "weeklyReport_1on1HsPres",      :limit => 10, :default => 0,  :null => false
    t.integer "staff_id",                     :limit => 10, :default => 0,  :null => false
    t.integer "week_id",                      :limit => 10, :default => 0,  :null => false
    t.integer "campus_id",                    :limit => 10, :default => 0,  :null => false
    t.integer "weeklyReport_7upCompleted",    :limit => 10, :default => 0,  :null => false
    t.integer "weeklyReport_1on1SpConvStd",   :limit => 10, :default => 0,  :null => false
    t.integer "weeklyReport_1on1GosPresStd",  :limit => 10, :default => 0,  :null => false
    t.integer "weeklyReport_1on1HsPresStd",   :limit => 10, :default => 0,  :null => false
    t.integer "weeklyReport_7upCompletedStd", :limit => 10, :default => 0,  :null => false
    t.integer "weeklyReport_cjVideo",         :limit => 10, :default => 0,  :null => false
    t.integer "weeklyReport_mda",             :limit => 10, :default => 0,  :null => false
    t.integer "weeklyReport_otherEVMats",     :limit => 10, :default => 0,  :null => false
    t.integer "weeklyReport_rlk",             :limit => 10, :default => 0,  :null => false
    t.integer "weeklyReport_siq",             :limit => 10, :default => 0,  :null => false
    t.text    "weeklyReport_notes",                         :default => "", :null => false
  end

  create_table "cim_stats_year", :primary_key => "year_id", :force => true do |t|
    t.string "year_desc", :limit => 32, :default => "", :null => false
  end

  create_table "gtw_projects", :primary_key => "projects_id", :force => true do |t|
    t.string "projects_desc",   :limit => 50,  :default => "", :null => false
    t.string "project_website", :limit => 200
  end

  create_table "gtw_role", :primary_key => "role_id", :force => true do |t|
    t.string "role_desc", :limit => 64, :default => "", :null => false
  end

  create_table "gtw_story", :primary_key => "story_id", :force => true do |t|
    t.string  "story_email", :limit => 128, :default => "", :null => false
    t.string  "story_name",  :limit => 128, :default => "", :null => false
    t.integer "campus_id",   :limit => 10,  :default => 0,  :null => false
    t.integer "projects_id", :limit => 10,  :default => 0,  :null => false
    t.text    "story_story",                :default => "", :null => false
    t.integer "role_id",     :limit => 10,  :default => 0,  :null => false
  end

  create_table "multi_gen_buttons", :primary_key => "button_id", :force => true do |t|
    t.integer "site_id",                    :default => 0,  :null => false
    t.string  "button_key",   :limit => 50, :default => "", :null => false
    t.string  "button_value", :limit => 50, :default => "", :null => false
    t.integer "language_id",  :limit => 4,  :default => 1,  :null => false
  end

  create_table "multi_labels", :primary_key => "labels_id", :force => true do |t|
    t.integer "page_id",                      :default => 0,  :null => false
    t.integer "language_id",    :limit => 4,  :default => 0,  :null => false
    t.string  "labels_key",     :limit => 50, :default => "", :null => false
    t.text    "labels_label",                 :default => "", :null => false
    t.text    "labels_caption"
  end

  add_index "multi_labels", ["page_id"], :name => "page_id"
  add_index "multi_labels", ["language_id"], :name => "language_id"

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
    t.integer "viewer_id",                        :default => 0,  :null => false
    t.integer "language_id",                      :default => 0,  :null => false
    t.text    "navbarcache_cache",                :default => "", :null => false
    t.integer "navbarcache_isValid", :limit => 1, :default => 0,  :null => false
  end

  create_table "navbar_navbargroup", :primary_key => "navbargroup_id", :force => true do |t|
    t.string  "navbargroup_nameKey", :limit => 50, :default => "", :null => false
    t.integer "navbargroup_order",                 :default => 0,  :null => false
  end

  create_table "navbar_navbarlinks", :primary_key => "navbarlink_id", :force => true do |t|
    t.integer  "navbargroup_id",                         :default => 0,                     :null => false
    t.string   "navbarlink_textKey",       :limit => 50, :default => "",                    :null => false
    t.text     "navbarlink_url",                         :default => "",                    :null => false
    t.integer  "module_id",                              :default => 0,                     :null => false
    t.integer  "navbarlink_isActive",      :limit => 1,  :default => 0,                     :null => false
    t.integer  "navbarlink_isModule",      :limit => 1,  :default => 0,                     :null => false
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

  create_table "p2c_stats_division", :primary_key => "division_id", :force => true do |t|
    t.string  "division_name", :limit => 64,  :default => "", :null => false
    t.string  "division_desc", :limit => 128, :default => "", :null => false
    t.integer "ministry_id",   :limit => 20,  :default => 0,  :null => false
  end

  add_index "p2c_stats_division", ["ministry_id"], :name => "FK_div_min"

  create_table "p2c_stats_frequency", :primary_key => "freq_id", :force => true do |t|
    t.string  "freq_name",                    :limit => 32, :default => "", :null => false
    t.string  "freq_desc",                    :limit => 64, :default => "", :null => false
    t.integer "freq_parent_date_field_index", :limit => 4,  :default => 0,  :null => false
    t.string  "freq_parent_date_field_name",  :limit => 24, :default => "", :null => false
    t.integer "freq_parent_freq_id",          :limit => 20, :default => 0,  :null => false
  end

  create_table "p2c_stats_frequency_parent_field", :primary_key => "freq_id", :force => true do |t|
    t.integer "frequency_parent_field_date_index", :limit => 4,  :default => 0,  :null => false
    t.string  "frequency_parent_field_date_name",  :limit => 24, :default => "", :null => false
  end

  create_table "p2c_stats_freqvalue", :primary_key => "freqvalue_id", :force => true do |t|
    t.integer  "freq_id",         :limit => 20, :default => 0,  :null => false
    t.datetime "freqvalue_value"
    t.string   "freqvalue_desc",  :limit => 48, :default => "", :null => false
  end

  add_index "p2c_stats_freqvalue", ["freq_id"], :name => "FK_freqvalue_freqtype"

  create_table "p2c_stats_location", :primary_key => "location_id", :force => true do |t|
    t.string  "location_name", :limit => 64,  :default => "", :null => false
    t.string  "location_desc", :limit => 128, :default => "", :null => false
    t.integer "region_id",     :limit => 50,  :default => 0,  :null => false
    t.integer "division_id",   :limit => 50,  :default => 0,  :null => false
    t.integer "ministry_id",   :limit => 20,  :default => 0,  :null => false
  end

  add_index "p2c_stats_location", ["ministry_id"], :name => "FK_location_min"
  add_index "p2c_stats_location", ["region_id"], :name => "FK_location_region"

  create_table "p2c_stats_measure", :primary_key => "meas_id", :force => true do |t|
    t.string "meas_name", :limit => 64,  :default => "", :null => false
    t.string "meas_desc", :limit => 128, :default => "", :null => false
  end

  create_table "p2c_stats_ministry", :primary_key => "ministry_id", :force => true do |t|
    t.string "ministry_name",    :limit => 64,  :default => "", :null => false
    t.string "ministry_desc",    :limit => 128, :default => "", :null => false
    t.string "ministry_website", :limit => 48,  :default => "", :null => false
  end

  create_table "p2c_stats_region", :primary_key => "region_id", :force => true do |t|
    t.string  "region_name", :limit => 64,  :default => "", :null => false
    t.string  "region_desc", :limit => 128, :default => "", :null => false
    t.integer "division_id", :limit => 50,  :default => 0,  :null => false
    t.integer "ministry_id", :limit => 20,  :default => 0,  :null => false
  end

  add_index "p2c_stats_region", ["ministry_id"], :name => "FK_region_min"

  create_table "p2c_stats_reportfilter", :primary_key => "filter_id", :force => true do |t|
    t.string "filter_name", :limit => 64,  :default => "", :null => false
    t.string "filter_desc", :limit => 128, :default => "", :null => false
  end

  create_table "p2c_stats_savedform", :primary_key => "savedform_id", :force => true do |t|
    t.integer  "viewer_id",                          :default => 0, :null => false
    t.integer  "page_id",              :limit => 50, :default => 0, :null => false
    t.integer  "ministry_id",          :limit => 20, :default => 0, :null => false
    t.integer  "division_id",          :limit => 50, :default => 0, :null => false
    t.integer  "region_id",            :limit => 50, :default => 0, :null => false
    t.integer  "location_id",          :limit => 50, :default => 0, :null => false
    t.integer  "freq_id",              :limit => 50, :default => 0, :null => false
    t.integer  "meas_id",              :limit => 20, :default => 0, :null => false
    t.datetime "savedform_startpoint",                              :null => false
    t.datetime "savedform_endpoint",                                :null => false
    t.integer  "savedform_isfiltered", :limit => 1,  :default => 0, :null => false
  end

  add_index "p2c_stats_savedform", ["ministry_id"], :name => "FK_form_ministry"
  add_index "p2c_stats_savedform", ["freq_id"], :name => "FK_form_freq"
  add_index "p2c_stats_savedform", ["meas_id"], :name => "FK_form_measure"
  add_index "p2c_stats_savedform", ["viewer_id"], :name => "FK_form_viewer"
  add_index "p2c_stats_savedform", ["page_id"], :name => "FK_form_page"

  create_table "p2c_stats_savedformfilters", :id => false, :force => true do |t|
    t.integer "savedform_id", :limit => 50, :default => 0
    t.integer "filter_id",    :limit => 20, :default => 0
  end

  add_index "p2c_stats_savedformfilters", ["savedform_id"], :name => "FK_filter_form"
  add_index "p2c_stats_savedformfilters", ["filter_id"], :name => "FK_filter_type"

  create_table "p2c_stats_savedformstats", :id => false, :force => true do |t|
    t.integer "savedform_id", :limit => 25, :default => 0, :null => false
    t.integer "stat_id",      :limit => 50, :default => 0, :null => false
  end

  add_index "p2c_stats_savedformstats", ["savedform_id"], :name => "FK_stat_form"
  add_index "p2c_stats_savedformstats", ["stat_id"], :name => "FK_stat_desc"

  create_table "p2c_stats_scope", :primary_key => "scope_id", :force => true do |t|
    t.string "scope_name",     :limit => 64, :default => "", :null => false
    t.string "scope_reftable", :limit => 32, :default => "", :null => false
  end

  create_table "p2c_stats_statistic", :primary_key => "statistic_id", :force => true do |t|
    t.string  "statistic_name",    :limit => 64,  :default => "", :null => false
    t.string  "statistic_desc",    :limit => 128, :default => "", :null => false
    t.integer "statistic_type_id", :limit => 4,   :default => 0,  :null => false
    t.integer "scope_id",          :limit => 10,  :default => 0,  :null => false
    t.integer "scope_ref_id",      :limit => 50,  :default => 0,  :null => false
    t.integer "freq_id",           :limit => 20,  :default => 0,  :null => false
    t.integer "meas_id",           :limit => 20,  :default => 0,  :null => false
  end

  add_index "p2c_stats_statistic", ["scope_id"], :name => "FK_stat_scope"
  add_index "p2c_stats_statistic", ["freq_id"], :name => "FK_stat_freq"
  add_index "p2c_stats_statistic", ["meas_id"], :name => "FK_stat_meas"
  add_index "p2c_stats_statistic", ["statistic_type_id"], :name => "FK_stat_type"

  create_table "p2c_stats_stattag", :id => false, :force => true do |t|
    t.integer "stat_id", :limit => 50, :default => 0, :null => false
    t.integer "tag_id",  :limit => 50, :default => 0, :null => false
  end

  add_index "p2c_stats_stattag", ["stat_id"], :name => "FK_tag_stats"
  add_index "p2c_stats_stattag", ["tag_id"], :name => "FK_stat_tag"

  create_table "p2c_stats_stattype", :primary_key => "statistic_type_id", :force => true do |t|
    t.string "statistic_type", :limit => 32, :default => "", :null => false
  end

  create_table "p2c_stats_statvalues", :primary_key => "statvalues_id", :force => true do |t|
    t.integer   "statistic_id",       :limit => 50, :default => 0,  :null => false
    t.integer   "scope_id",           :limit => 10, :default => 0,  :null => false
    t.integer   "scope_ref_id",       :limit => 50, :default => 0,  :null => false
    t.string    "statvalues_value",   :limit => 64, :default => "", :null => false
    t.integer   "freqvalue_id",       :limit => 50, :default => 0,  :null => false
    t.integer   "meastype_id",        :limit => 20, :default => 0,  :null => false
    t.timestamp "statvalues_modtime"
    t.integer   "person_id",          :limit => 50, :default => 0,  :null => false
  end

  add_index "p2c_stats_statvalues", ["statistic_id"], :name => "FK_value_stat"
  add_index "p2c_stats_statvalues", ["scope_id"], :name => "FK_value_scope"
  add_index "p2c_stats_statvalues", ["freqvalue_id"], :name => "FK_value_freqval"
  add_index "p2c_stats_statvalues", ["meastype_id"], :name => "FK_value_measure"
  add_index "p2c_stats_statvalues", ["person_id"], :name => "FK_value_person"

  create_table "p2c_stats_tag", :primary_key => "tag_id", :force => true do |t|
    t.string  "tag_name",     :limit => 64,  :default => "", :null => false
    t.string  "tag_desc",     :limit => 128, :default => "", :null => false
    t.integer "scope_id",     :limit => 10,  :default => 0,  :null => false
    t.integer "scope_ref_id", :limit => 50,  :default => 0,  :null => false
  end

  add_index "p2c_stats_tag", ["scope_id"], :name => "FK_tag_scope"

  create_table "qrious_questions", :primary_key => "questions_id", :force => true do |t|
    t.integer "campus_id",          :limit => 8,  :default => 0,  :null => false
    t.string  "questions_email",    :limit => 64, :default => "", :null => false
    t.text    "questions_question",               :default => "", :null => false
  end

  create_table "rad_dafield", :primary_key => "dafield_id", :force => true do |t|
    t.integer "daobj_id",                            :default => 0,  :null => false
    t.integer "statevar_id",                         :default => -1, :null => false
    t.string  "dafield_name",          :limit => 50, :default => "", :null => false
    t.text    "dafield_desc",                        :default => "", :null => false
    t.string  "dafield_type",          :limit => 50, :default => "", :null => false
    t.string  "dafield_dbType",        :limit => 50, :default => "", :null => false
    t.string  "dafield_formFieldType", :limit => 50, :default => "", :null => false
    t.integer "dafield_isPrimaryKey",  :limit => 1,  :default => 0,  :null => false
    t.integer "dafield_isForeignKey",  :limit => 1,  :default => 0,  :null => false
    t.integer "dafield_isNullable",    :limit => 1,  :default => 0,  :null => false
    t.string  "dafield_default",       :limit => 50, :default => "", :null => false
    t.string  "dafield_invalidValue",  :limit => 50, :default => "", :null => false
    t.integer "dafield_isLabelName",   :limit => 1,  :default => 0,  :null => false
    t.integer "dafield_isListInit",    :limit => 1,  :default => 0,  :null => false
    t.integer "dafield_isCreated",     :limit => 1,  :default => 0,  :null => false
    t.text    "dafield_title",                       :default => "", :null => false
    t.text    "dafield_formLabel",                   :default => "", :null => false
    t.text    "dafield_example",                     :default => "", :null => false
    t.text    "dafield_error",                       :default => "", :null => false
  end

  create_table "rad_daobj", :primary_key => "daobj_id", :force => true do |t|
    t.integer "module_id",                             :default => 0,  :null => false
    t.string  "daobj_name",             :limit => 50,  :default => "", :null => false
    t.text    "daobj_desc",                            :default => "", :null => false
    t.string  "daobj_dbTableName",      :limit => 100, :default => "", :null => false
    t.integer "daobj_managerInitVarID",                :default => 0,  :null => false
    t.integer "daobj_listInitVarID",                   :default => 0,  :null => false
    t.integer "daobj_isCreated",        :limit => 1,   :default => 0,  :null => false
    t.integer "daobj_isUpdated",        :limit => 1,   :default => 0,  :null => false
  end

  create_table "rad_module", :primary_key => "module_id", :force => true do |t|
    t.string  "module_name",         :limit => 50, :default => "", :null => false
    t.text    "module_desc",                       :default => "", :null => false
    t.text    "module_creatorName",                :default => "", :null => false
    t.integer "module_isCommonLook", :limit => 1,  :default => 0,  :null => false
    t.integer "module_isCore",       :limit => 1,  :default => 0,  :null => false
    t.integer "module_isCreated",    :limit => 1,  :default => 0,  :null => false
  end

  create_table "rad_page", :primary_key => "page_id", :force => true do |t|
    t.integer "module_id",                    :default => 0,  :null => false
    t.string  "page_name",      :limit => 50, :default => "", :null => false
    t.text    "page_desc",                    :default => "", :null => false
    t.string  "page_type",      :limit => 5,  :default => "", :null => false
    t.integer "page_isAdd",     :limit => 1,  :default => 0,  :null => false
    t.integer "page_rowMgrID",                :default => 0,  :null => false
    t.integer "page_listMgrID",               :default => 0,  :null => false
    t.integer "page_isCreated", :limit => 1,  :default => 0,  :null => false
    t.integer "page_isDefault", :limit => 1,  :default => 0,  :null => false
  end

  create_table "rad_pagefield", :primary_key => "pagefield_id", :force => true do |t|
    t.integer "page_id",                       :default => 0, :null => false
    t.integer "daobj_id",                      :default => 0, :null => false
    t.integer "dafield_id",                    :default => 0, :null => false
    t.integer "pagefield_isForm", :limit => 1, :default => 0, :null => false
  end

  create_table "rad_pagelabels", :primary_key => "pagelabel_id", :force => true do |t|
    t.integer "page_id",                           :default => 0,  :null => false
    t.string  "pagelabel_key",       :limit => 50, :default => "", :null => false
    t.text    "pagelabel_label",                   :default => "", :null => false
    t.integer "language_id",                       :default => 0,  :null => false
    t.integer "pagelabel_isCreated", :limit => 1,  :default => 0,  :null => false
  end

  create_table "rad_statevar", :primary_key => "statevar_id", :force => true do |t|
    t.integer "module_id",                        :default => 0,        :null => false
    t.string  "statevar_name",      :limit => 50, :default => "",       :null => false
    t.text    "statevar_desc",                    :default => "",       :null => false
    t.string  "statevar_type",      :limit => 0,  :default => "STRING", :null => false
    t.string  "statevar_default",   :limit => 50, :default => "",       :null => false
    t.integer "statevar_isCreated", :limit => 1,  :default => 0,        :null => false
    t.integer "statevar_isUpdated", :limit => 1,  :default => 0,        :null => false
  end

  create_table "rad_transitions", :primary_key => "transition_id", :force => true do |t|
    t.integer "module_id",                          :default => 0,  :null => false
    t.integer "transition_fromObjID",               :default => 0,  :null => false
    t.integer "transition_toObjID",                 :default => 0,  :null => false
    t.string  "transition_type",      :limit => 10, :default => "", :null => false
    t.integer "transition_isCreated", :limit => 1,  :default => 0,  :null => false
  end

  create_table "sch_access_permission", :primary_key => "access_permission_id", :force => true do |t|
    t.integer "user_id",         :default => 0, :null => false
    t.integer "organization_id", :default => 0, :null => false
    t.integer "sub_group_id",    :default => 0, :null => false
  end

  add_index "sch_access_permission", ["access_permission_id"], :name => "access_permission_id"

  create_table "sch_person_sub_group", :primary_key => "person_sub_group_id", :force => true do |t|
    t.float "person_id",             :default => 0.0, :null => false
    t.float "sub_group_id",          :default => 0.0, :null => false
    t.float "organization_id",       :default => 0.0, :null => false
    t.date  "person_sub_group_time",                  :null => false
  end

  add_index "sch_person_sub_group", ["person_sub_group_id"], :name => "person_sub_group_id"

  create_table "sch_schedule", :primary_key => "schedule_id", :force => true do |t|
    t.float "person_id",      :null => false
    t.float "schedule_block", :null => false
  end

  add_index "sch_schedule", ["schedule_id"], :name => "schedule_id"

  create_table "sch_sub_group", :primary_key => "sub_group_id", :force => true do |t|
    t.text    "name",                  :default => "", :null => false
    t.integer "organization_id",       :default => 0,  :null => false
    t.text    "notification_email_to"
  end

  create_table "site_logmanager", :primary_key => "log_id", :force => true do |t|
    t.string   "log_userID",         :limit => 50, :default => "", :null => false
    t.datetime "log_dateTime",                                     :null => false
    t.string   "log_recipientID",    :limit => 50, :default => "", :null => false
    t.text     "log_description",                  :default => "", :null => false
    t.text     "log_data",                         :default => "", :null => false
    t.string   "log_viewerIP",       :limit => 15, :default => "", :null => false
    t.string   "log_applicationKey", :limit => 4,  :default => "", :null => false
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

  add_index "site_multilingual_xlation", ["language_id"], :name => "language_id"
  add_index "site_multilingual_xlation", ["label_id"], :name => "label_id"

  create_table "site_page_modules", :primary_key => "module_id", :force => true do |t|
    t.string "module_key",              :limit => 50, :default => "", :null => false
    t.text   "module_path",                           :default => "", :null => false
    t.string "module_app",              :limit => 50, :default => "", :null => false
    t.string "module_include",          :limit => 50, :default => "", :null => false
    t.string "module_name",             :limit => 50, :default => "", :null => false
    t.text   "module_parameters",                     :default => "", :null => false
    t.string "module_systemAccessFile", :limit => 50, :default => "", :null => false
    t.string "module_systemAccessObj",  :limit => 50, :default => "", :null => false
  end

  create_table "site_session", :primary_key => "session_id", :force => true do |t|
    t.text    "session_data",       :default => "", :null => false
    t.integer "session_expiration", :default => 0,  :null => false
  end

  create_table "spt_ticket", :primary_key => "ticket_id", :force => true do |t|
    t.integer "viewer_id",     :limit => 8,  :default => 0,  :null => false
    t.string  "ticket_ticket", :limit => 64, :default => "", :null => false
    t.integer "ticket_expiry", :limit => 16, :default => 0,  :null => false
  end

  create_table "temp_mb_early_frosh", :primary_key => "registration_id", :force => true do |t|
  end

  create_table "test_table", :primary_key => "test_id", :force => true do |t|
  end

  create_table "test_table2", :primary_key => "qa_id", :force => true do |t|
  end

end
