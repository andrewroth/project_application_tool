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

ActiveRecord::Schema.define(:version => 20100426181222) do

  create_table "addresses", :force => true do |t|
    t.integer "person_id"
    t.string  "address_type"
    t.string  "title"
    t.string  "address1"
    t.string  "address2"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.string  "country"
    t.string  "phone"
    t.string  "alternate_phone"
    t.string  "dorm"
    t.string  "room"
    t.string  "email"
    t.date    "start_date"
    t.date    "end_date"
    t.date    "created_at"
    t.date    "updated_at"
    t.boolean "email_validated"
  end

  add_index "addresses", ["email"], :name => "index_addresses_on_email"
  add_index "addresses", ["person_id"], :name => "index_addresses_on_person_id"

  create_table "airports", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "city"
    t.string   "country_code"
    t.string   "area_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applns", :force => true do |t|
    t.integer  "form_id"
    t.integer  "viewer_id"
    t.datetime "updated_at"
    t.integer  "preference1_id"
    t.integer  "preference2_id"
    t.datetime "submitted_at"
    t.boolean  "as_intern",      :default => false
  end

  add_index "applns", ["as_intern"], :name => "applns_as_intern_index"
  add_index "applns", ["form_id"], :name => "applns_form_id_index"
  add_index "applns", ["preference1_id"], :name => "applns_preference1_id_index"
  add_index "applns", ["preference2_id"], :name => "applns_preference2_id_index"
  add_index "applns", ["viewer_id"], :name => "applns_viewer_id_index"

  create_table "campus_involvements", :force => true do |t|
    t.integer "person_id"
    t.integer "campus_id"
    t.date    "start_date"
    t.date    "end_date"
    t.integer "ministry_id"
    t.integer "added_by_id"
    t.date    "graduation_date"
    t.integer "school_year_id"
    t.string  "major"
    t.string  "minor"
    t.date    "last_history_update_date"
  end

  add_index "campus_involvements", ["campus_id"], :name => "index_campus_involvements_on_campus_id"
  add_index "campus_involvements", ["ministry_id"], :name => "index_campus_involvements_on_ministry_id"
  add_index "campus_involvements", ["person_id", "campus_id", "end_date"], :name => "index_campus_involvements_on_p_id_and_c_id_and_end_date", :unique => true
  add_index "campus_involvements", ["person_id"], :name => "index_campus_involvements_on_person_id"

  create_table "campuses", :force => true do |t|
    t.string  "name"
    t.string  "address"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.string  "country"
    t.string  "phone"
    t.string  "fax"
    t.string  "url"
    t.string  "abbrv"
    t.boolean "is_secure"
    t.integer "enrollment"
    t.date    "created_at"
    t.date    "updated_at"
    t.string  "type"
    t.string  "address2"
    t.string  "county"
  end

  add_index "campuses", ["county"], :name => "index_campuses_on_county"
  add_index "campuses", ["name"], :name => "index_campuses_on_name"

  create_table "columns", :force => true do |t|
    t.string   "title"
    t.string   "update_clause"
    t.string   "from_clause"
    t.text     "select_clause"
    t.string   "column_type"
    t.string   "writeable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "join_clause"
    t.string   "source_model"
    t.string   "source_column"
    t.string   "foreign_key"
  end

  create_table "conference_registrations", :force => true do |t|
    t.integer  "conference_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conferences", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cost_items", :force => true do |t|
    t.string  "type"
    t.string  "description"
    t.decimal "amount",         :precision => 8, :scale => 2
    t.boolean "optional"
    t.integer "year"
    t.integer "project_id"
    t.integer "profile_id"
    t.integer "event_group_id"
  end

  add_index "cost_items", ["event_group_id"], :name => "index_cost_items_on_event_group_id"
  add_index "cost_items", ["type"], :name => "cost_items_type_index"
  add_index "cost_items", ["year"], :name => "cost_items_year_index"

  create_table "counties", :force => true do |t|
    t.string "name"
    t.string "state"
  end

  add_index "counties", ["state"], :name => "index_counties_on_state"

  create_table "countries", :force => true do |t|
    t.string  "country"
    t.string  "code"
    t.boolean "is_closed"
    t.string  "iso_code"
    t.boolean "closed",    :default => false
  end

  create_table "custom_attributes", :force => true do |t|
    t.integer "ministry_id"
    t.string  "name"
    t.string  "value_type"
    t.string  "description"
    t.string  "type"
  end

  add_index "custom_attributes", ["type"], :name => "index_custom_attributes_on_type"

  create_table "custom_element_required_sections", :force => true do |t|
    t.integer  "element_id"
    t.string   "name"
    t.string   "attribute"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "custom_values", :force => true do |t|
    t.integer "person_id"
    t.integer "custom_attribute_id"
    t.string  "value"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.string   "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "donation_types", :force => true do |t|
    t.string "description"
  end

  add_index "donation_types", ["description"], :name => "donation_types_description_index"

  create_table "dorms", :force => true do |t|
    t.integer "campus_id"
    t.string  "name"
    t.date    "created_at"
  end

  add_index "dorms", ["campus_id"], :name => "index_dorms_on_campus_id"

  create_table "emails", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.text     "people_ids"
    t.text     "missing_address_ids"
    t.integer  "search_id"
    t.integer  "sender_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emergs", :force => true do |t|
    t.integer "person_id"
    t.string  "passport_num"
    t.string  "passport_origin"
    t.string  "passport_expiry"
    t.text    "notes"
    t.text    "meds"
    t.string  "health_coverage_state"
    t.string  "health_number"
    t.string  "medical_plan_number"
    t.string  "medical_plan_carrier"
    t.string  "doctor_name"
    t.string  "doctor_phone"
    t.string  "dentist_name"
    t.string  "dentist_phone"
    t.string  "blood_type"
    t.string  "blood_rh_factor"
    t.string  "health_coverage_country"
  end

  create_table "event_groups", :force => true do |t|
    t.string  "title"
    t.integer "parent_id"
    t.string  "type"
    t.string  "location_type"
    t.integer "location_id"
    t.string  "long_desc"
    t.integer "default_text_area_length", :default => 4000
    t.boolean "has_your_campuses"
    t.string  "outgoing_email"
    t.boolean "hidden",                   :default => false
    t.string  "content_type"
    t.string  "filename"
    t.string  "thumbnail"
    t.integer "size"
    t.integer "width"
    t.integer "height"
    t.boolean "show_mpdtool",             :default => false
  end

  create_table "eventgroup_coordinators", :force => true do |t|
    t.integer  "viewer_id"
    t.integer  "event_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", :force => true do |t|
    t.integer  "viewer_id"
    t.text     "feedback_type"
    t.text     "description"
    t.datetime "created_at"
    t.integer  "event_group_id"
  end

  add_index "feedbacks", ["event_group_id"], :name => "index_feedbacks_on_event_group_id"
  add_index "feedbacks", ["viewer_id"], :name => "feedbacks_viewer_id_index"

  create_table "form_answers", :force => true do |t|
    t.integer "question_id"
    t.integer "instance_id"
    t.text    "answer"
  end

  add_index "form_answers", ["instance_id"], :name => "form_answers_instance_id_index"
  add_index "form_answers", ["question_id", "instance_id"], :name => "form_answers_question_id_index", :unique => true

  create_table "form_element_flags", :force => true do |t|
    t.integer "element_id"
    t.integer "flag_id"
    t.boolean "value"
  end

  add_index "form_element_flags", ["element_id"], :name => "form_element_flags_element_id_index"
  add_index "form_element_flags", ["flag_id"], :name => "form_element_flags_flag_id_index"
  add_index "form_element_flags", ["value"], :name => "form_element_flags_value_index"

  create_table "form_elements", :force => true do |t|
    t.integer  "parent_id"
    t.string   "type",            :limit => 50
    t.text     "text"
    t.boolean  "is_required"
    t.string   "question_table",  :limit => 50
    t.string   "question_column", :limit => 50
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "dependency_id"
    t.integer  "max_length",                    :default => 0, :null => false
  end

  add_index "form_elements", ["parent_id"], :name => "form_elements_parent_id_index"
  add_index "form_elements", ["position"], :name => "form_elements_position_index"
  add_index "form_elements", ["type"], :name => "form_elements_type_index"

  create_table "form_flags", :force => true do |t|
    t.string "name"
    t.string "element_txt"
    t.string "group_txt"
  end

  create_table "form_page_elements", :force => true do |t|
    t.integer  "page_id"
    t.integer  "element_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "form_page_elements", ["element_id"], :name => "form_page_elements_element_id_index"
  add_index "form_page_elements", ["page_id"], :name => "form_page_elements_page_id_index"
  add_index "form_page_elements", ["position"], :name => "form_page_elements_position_index"

  create_table "form_page_flags", :force => true do |t|
    t.integer "page_id"
    t.integer "flag_id"
    t.boolean "value"
  end

  add_index "form_page_flags", ["flag_id"], :name => "form_page_flags_flag_id_index"
  add_index "form_page_flags", ["page_id"], :name => "form_page_flags_page_id_index"
  add_index "form_page_flags", ["value"], :name => "form_page_flags_value_index"

  create_table "form_pages", :force => true do |t|
    t.string   "title",         :limit => 50
    t.string   "url_name",      :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "hidden"
  end

  create_table "form_question_options", :force => true do |t|
    t.integer  "question_id"
    t.string   "option",      :limit => 256
    t.string   "value",       :limit => 50
    t.integer  "position"
    t.datetime "created_at"
  end

  add_index "form_question_options", ["option"], :name => "form_question_options_option_index"
  add_index "form_question_options", ["position"], :name => "form_question_options_position_index"
  add_index "form_question_options", ["question_id"], :name => "form_question_options_question_id_index"
  add_index "form_question_options", ["value"], :name => "form_question_options_value_index"

  create_table "form_questionnaire_pages", :force => true do |t|
    t.integer  "questionnaire_id"
    t.integer  "page_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "form_questionnaire_pages", ["page_id"], :name => "form_questionnaire_pages_page_id_index"
  add_index "form_questionnaire_pages", ["position"], :name => "form_questionnaire_pages_position_index"
  add_index "form_questionnaire_pages", ["questionnaire_id"], :name => "form_questionnaire_pages_questionnaire_id_index"

  create_table "form_reference_attributes", :force => true do |t|
    t.integer "reference_id"
    t.integer "questionnaire_id"
  end

  create_table "forms", :force => true do |t|
    t.string  "name"
    t.string  "category"
    t.integer "year"
    t.integer "questionnaire_id"
    t.integer "event_group_id"
    t.boolean "hidden"
  end

  add_index "forms", ["event_group_id"], :name => "index_forms_on_event_group_id"
  add_index "forms", ["questionnaire_id"], :name => "forms_questionnaire_id_index"

  create_table "free_times", :force => true do |t|
    t.integer  "start_time"
    t.integer  "end_time"
    t.integer  "day_of_week"
    t.integer  "timetable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "css_class"
    t.decimal  "weight",       :precision => 4, :scale => 2
  end

  create_table "group_involvements", :force => true do |t|
    t.integer "person_id"
    t.integer "group_id"
    t.string  "level"
    t.boolean "requested"
  end

  add_index "group_involvements", ["person_id", "group_id"], :name => "person_id_group_id", :unique => true

  create_table "group_types", :force => true do |t|
    t.integer  "ministry_id"
    t.string   "group_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "mentor_priority"
    t.boolean  "public"
    t.integer  "unsuitability_leader"
    t.integer  "unsuitability_coleader"
    t.integer  "unsuitability_participant"
  end

  create_table "groups", :force => true do |t|
    t.string  "name"
    t.string  "address"
    t.string  "address_2"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.string  "country"
    t.string  "email"
    t.string  "url"
    t.integer "dorm_id"
    t.integer "ministry_id"
    t.integer "campus_id"
    t.integer "start_time"
    t.integer "end_time"
    t.integer "day"
    t.integer "group_type_id"
    t.boolean "needs_approval"
  end

  add_index "groups", ["campus_id"], :name => "index_groups_on_campus_id"
  add_index "groups", ["dorm_id"], :name => "index_groups_on_dorm_id"
  add_index "groups", ["ministry_id"], :name => "index_groups_on_ministry_id"

  create_table "imports", :force => true do |t|
    t.integer  "person_id"
    t.integer  "parent_id"
    t.integer  "size"
    t.integer  "height"
    t.integer  "width"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "involvement_histories", :force => true do |t|
    t.string   "type"
    t.integer  "person_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "campus_id"
    t.integer  "school_year_id"
    t.integer  "ministry_id"
    t.integer  "ministry_role_id"
    t.integer  "campus_involvement_id"
    t.integer  "ministry_involvement_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manual_donations", :force => true do |t|
    t.string   "motivation_code"
    t.datetime "created_at"
    t.string   "donor_name"
    t.integer  "donation_type_id"
    t.decimal  "original_amount",  :precision => 8, :scale => 2
    t.decimal  "amount",           :precision => 8, :scale => 2
    t.string   "status"
    t.float    "conversion_rate"
  end

  add_index "manual_donations", ["motivation_code"], :name => "manual_donations_motivation_code_index"

  create_table "ministries", :force => true do |t|
    t.integer "parent_id"
    t.string  "name"
    t.string  "address"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.string  "country"
    t.string  "phone"
    t.string  "fax"
    t.string  "email"
    t.string  "url"
    t.date    "created_at"
    t.date    "updated_at"
    t.integer "ministries_count"
  end

  add_index "ministries", ["parent_id"], :name => "index_ministries_on_parent_id"

  create_table "ministry_campuses", :force => true do |t|
    t.integer "ministry_id"
    t.integer "campus_id"
  end

  add_index "ministry_campuses", ["ministry_id", "campus_id"], :name => "index_ministry_campuses_on_ministry_id_and_campus_id", :unique => true

  create_table "ministry_involvements", :force => true do |t|
    t.integer "person_id"
    t.integer "ministry_id"
    t.date    "start_date"
    t.date    "end_date"
    t.boolean "admin"
    t.integer "ministry_role_id"
    t.integer "responsible_person_id"
    t.date    "last_history_update_date"
  end

  add_index "ministry_involvements", ["person_id"], :name => "index_ministry_involvements_on_person_id"

  create_table "ministry_role_permissions", :force => true do |t|
    t.integer "permission_id"
    t.integer "ministry_role_id"
    t.string  "created_at"
  end

  create_table "ministry_roles", :force => true do |t|
    t.integer "ministry_id"
    t.string  "name"
    t.date    "created_at"
    t.integer "position"
    t.string  "description"
    t.string  "type"
    t.boolean "involved"
  end

  add_index "ministry_roles", ["ministry_id"], :name => "index_ministry_roles_on_ministry_id"

  create_table "notification_acknowledgments", :force => true do |t|
    t.integer  "notification_id"
    t.integer  "viewer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.string   "controller"
    t.string   "action"
    t.text     "message"
    t.datetime "begin_time"
    t.datetime "end_time"
    t.boolean  "ignore_begin"
    t.boolean  "ignore_end"
    t.boolean  "no_hide_button"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "allow_html",     :default => false
  end

  create_table "optin_cost_items", :force => true do |t|
    t.integer "profile_id"
    t.integer "cost_item_id"
  end

  add_index "optin_cost_items", ["cost_item_id"], :name => "optin_cost_items_cost_item_id_index"
  add_index "optin_cost_items", ["profile_id"], :name => "optin_cost_items_profile_id_index"

  create_table "people", :force => true do |t|
    t.integer "user_id"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "middle_name"
    t.string  "preferred_first_name"
    t.string  "gender"
    t.string  "year_in_school"
    t.string  "level_of_school"
    t.date    "graduation_date"
    t.string  "major"
    t.string  "minor"
    t.date    "birth_date"
    t.text    "bio"
    t.string  "image"
    t.date    "created_at"
    t.date    "updated_at"
    t.string  "staff_notes"
    t.integer "updated_by"
    t.integer "created_by"
    t.string  "url",                           :limit => 2000
    t.integer "primary_campus_involvement_id"
    t.integer "mentor_id"
    t.string  "preferred_last_name"
  end

  add_index "people", ["first_name"], :name => "index_people_on_first_name"
  add_index "people", ["last_name", "first_name"], :name => "index_people_on_last_name_and_first_name"
  add_index "people", ["major", "minor"], :name => "index_people_on_major_and_minor"
  add_index "people", ["user_id"], :name => "index_people_on_user_id", :unique => true

  create_table "permissions", :force => true do |t|
    t.string "description", :limit => 1000
    t.string "controller"
    t.string "action"
  end

  create_table "plugin_schema_info", :id => false, :force => true do |t|
    t.string  "plugin_name"
    t.integer "version"
  end

  create_table "preferences", :force => true do |t|
    t.integer "viewer_id"
    t.string  "time_zone"
  end

  add_index "preferences", ["viewer_id"], :name => "preferences_viewer_id_index"

  create_table "prep_items", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.date     "deadline"
    t.integer  "event_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "individual",        :default => false
    t.boolean  "deadline_optional", :default => false
  end

  create_table "prep_items_projects", :id => false, :force => true do |t|
    t.integer "prep_item_id", :null => false
    t.integer "project_id",   :null => false
  end

  create_table "processor_forms", :force => true do |t|
    t.integer  "appln_id"
    t.datetime "updated_at"
  end

  add_index "processor_forms", ["appln_id"], :name => "processor_forms_appln_id_index"

  create_table "processors", :force => true do |t|
    t.integer "project_id"
    t.integer "viewer_id"
  end

  add_index "processors", ["project_id"], :name => "processors_project_id_index"
  add_index "processors", ["viewer_id"], :name => "processors_viewer_id_index"

  create_table "profile_donations", :force => true do |t|
    t.integer "profile_id"
    t.string  "type"
    t.integer "auto_donation_id"
    t.integer "manual_donation_id"
  end

  add_index "profile_donations", ["auto_donation_id"], :name => "profile_donations_auto_donation_id_index"
  add_index "profile_donations", ["manual_donation_id"], :name => "profile_donations_manual_donation_id_index"
  add_index "profile_donations", ["profile_id"], :name => "profile_donations_profile_id_index"
  add_index "profile_donations", ["type"], :name => "profile_donations_type_index"

  create_table "profile_notes", :force => true do |t|
    t.text     "content"
    t.integer  "profile_id"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profile_pictures", :force => true do |t|
    t.integer "person_id"
    t.integer "parent_id"
    t.integer "size"
    t.integer "height"
    t.integer "width"
    t.string  "content_type"
    t.string  "filename"
    t.string  "thumbnail"
    t.date    "uploaded_date"
  end

  create_table "profile_prep_items", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "prep_item_id"
    t.boolean  "submitted",    :default => false
    t.boolean  "received",     :default => false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "optional",     :default => false
  end

  create_table "profile_travel_segments", :force => true do |t|
    t.integer "profile_id"
    t.integer "travel_segment_id"
    t.integer "position"
    t.string  "eticket"
    t.string  "notes"
    t.string  "confirmation_number"
  end

  add_index "profile_travel_segments", ["position"], :name => "profile_travel_segments_position_index"
  add_index "profile_travel_segments", ["profile_id"], :name => "profile_travel_segments_profile_id_index"
  add_index "profile_travel_segments", ["travel_segment_id"], :name => "profile_travel_segments_travel_segment_id_index"

  create_table "profiles", :force => true do |t|
    t.integer  "appln_id"
    t.integer  "project_id"
    t.integer  "support_coach_id"
    t.float    "support_claimed"
    t.integer  "accepted_by_viewer_id"
    t.boolean  "as_intern",                                                :default => false
    t.string   "motivation_code",                                          :default => "0"
    t.string   "type"
    t.integer  "viewer_id"
    t.string   "status"
    t.integer  "locked_by"
    t.datetime "locked_at"
    t.datetime "completed_at"
    t.integer  "accepted_by"
    t.datetime "accepted_at"
    t.integer  "withdrawn_by"
    t.datetime "withdrawn_at"
    t.string   "status_when_withdrawn"
    t.string   "class_when_withdrawn"
    t.integer  "reason_id"
    t.string   "reason_notes"
    t.datetime "support_claimed_updated_at"
    t.datetime "confirmed_at"
    t.decimal  "cached_costing_total",       :precision => 8, :scale => 2
  end

  add_index "profiles", ["accepted_by"], :name => "profiles_accepted_by_index"
  add_index "profiles", ["appln_id"], :name => "profiles_appln_id_index"
  add_index "profiles", ["locked_by"], :name => "profiles_locked_by_index"
  add_index "profiles", ["project_id"], :name => "profiles_project_id_index"
  add_index "profiles", ["reason_id"], :name => "profiles_reason_id_index"
  add_index "profiles", ["support_coach_id"], :name => "profiles_support_coach_id_index"
  add_index "profiles", ["type"], :name => "profiles_type_index"
  add_index "profiles", ["viewer_id"], :name => "profiles_viewer_id_index"
  add_index "profiles", ["withdrawn_by"], :name => "profiles_withdrawn_by_index"

  create_table "project_administrators", :force => true do |t|
    t.integer "project_id"
    t.integer "viewer_id"
  end

  add_index "project_administrators", ["project_id"], :name => "project_administrators_project_id_index"
  add_index "project_administrators", ["viewer_id"], :name => "project_administrators_viewer_id_index"

  create_table "project_directors", :force => true do |t|
    t.integer "project_id"
    t.integer "viewer_id"
  end

  add_index "project_directors", ["project_id"], :name => "project_directors_project_id_index"
  add_index "project_directors", ["viewer_id"], :name => "project_directors_viewer_id_index"

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

  add_index "project_donations", ["participant_motv_code"], :name => "project_donations_participant_motv_code_index"

  create_table "project_staffs", :force => true do |t|
    t.integer "project_id"
    t.integer "viewer_id"
  end

  add_index "project_staffs", ["project_id"], :name => "project_staffs_project_id_index"
  add_index "project_staffs", ["viewer_id"], :name => "project_staffs_viewer_id_index"

  create_table "projects", :force => true do |t|
    t.string  "title"
    t.string  "description"
    t.date    "start"
    t.date    "end"
    t.integer "event_group_id"
    t.string  "cost_center"
    t.boolean "hidden",         :default => false
  end

  add_index "projects", ["event_group_id"], :name => "index_projects_on_event_group_id"

  create_table "projects_coordinators", :force => true do |t|
    t.integer  "viewer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questionnaires", :force => true do |t|
    t.string   "title",      :limit => 200
    t.string   "type",       :limit => 50
    t.datetime "created_at"
  end

  create_table "reason_for_withdrawals", :force => true do |t|
    t.string  "blurb"
    t.integer "event_group_id"
  end

  add_index "reason_for_withdrawals", ["event_group_id"], :name => "index_reason_for_withdrawals_on_event_group_id"

  create_table "reference_emails", :force => true do |t|
    t.string  "email_type"
    t.integer "year"
    t.text    "text"
    t.integer "event_group_id"
  end

  add_index "reference_emails", ["event_group_id"], :name => "index_reference_emails_on_event_group_id"

  create_table "reference_instances", :force => true do |t|
    t.integer  "instance_id"
    t.string   "email"
    t.string   "status"
    t.string   "access_key"
    t.datetime "email_sent_at"
    t.boolean  "is_staff"
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "accountNo"
    t.string   "home_phone"
    t.datetime "submitted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "mail",          :default => false
    t.boolean  "email_sent",    :default => false
    t.integer  "reference_id"
    t.string   "type"
  end

  add_index "reference_instances", ["access_key"], :name => "appln_references_access_key_index"
  add_index "reference_instances", ["instance_id"], :name => "appln_references_appln_id_index"
  add_index "reference_instances", ["status"], :name => "appln_references_status_index"

  create_table "report_elements", :force => true do |t|
    t.integer "report_id"
    t.integer "element_id"
    t.integer "report_model_method_id"
    t.integer "position"
    t.string  "type"
    t.string  "heading"
    t.integer "cost_item_id"
  end

  create_table "report_model_methods", :force => true do |t|
    t.integer "report_model_id"
    t.string  "method_s"
  end

  create_table "report_models", :force => true do |t|
    t.string "model_s"
  end

  create_table "reports", :force => true do |t|
    t.string  "title"
    t.integer "event_group_id"
    t.boolean "include_accepted", :default => true
    t.boolean "include_applying", :default => false
    t.boolean "include_staff",    :default => false
  end

  create_table "school_years", :force => true do |t|
    t.string   "name"
    t.string   "level"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.integer  "person_id"
    t.text     "options"
    t.text     "query"
    t.text     "tables"
    t.boolean  "saved"
    t.string   "name"
    t.string   "order"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "staff", :force => true do |t|
    t.integer "ministry_id"
    t.integer "person_id"
    t.date    "created_at"
  end

  add_index "staff", ["ministry_id"], :name => "index_staff_on_ministry_id"

  create_table "states", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stint_applications", :force => true do |t|
    t.integer  "stint_location_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stint_locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "summer_project_applications", :force => true do |t|
    t.integer  "summer_project_id"
    t.integer  "person_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "summer_projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "support_coaches", :force => true do |t|
    t.integer "project_id"
    t.integer "viewer_id"
  end

  add_index "support_coaches", ["project_id"], :name => "support_coaches_project_id_index"
  add_index "support_coaches", ["viewer_id"], :name => "support_coaches_viewer_id_index"

  create_table "taggings", :force => true do |t|
    t.string  "tagee_type"
    t.integer "tagee_id"
    t.integer "tag_id"
  end

  add_index "taggings", ["tag_id"], :name => "taggings_tag_id_index"
  add_index "taggings", ["tagee_id"], :name => "taggings_tagee_id_index"
  add_index "taggings", ["tagee_type"], :name => "taggings_tagee_type_index"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "event_group_id"
  end

  add_index "tags", ["event_group_id"], :name => "index_tags_on_event_group_id"

  create_table "timetables", :force => true do |t|
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "training_answers", :force => true do |t|
    t.integer  "training_question_id"
    t.integer  "person_id"
    t.date     "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "approved_by"
  end

  create_table "training_categories", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ministry_id"
  end

  create_table "training_question_activations", :force => true do |t|
    t.integer  "ministry_id"
    t.integer  "training_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "mandate"
  end

  create_table "training_questions", :force => true do |t|
    t.string   "activity"
    t.integer  "ministry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "training_category_id"
  end

  create_table "travel_segments", :force => true do |t|
    t.integer  "year"
    t.string   "departure_city"
    t.datetime "departure_time"
    t.string   "carrier"
    t.string   "arrival_city"
    t.datetime "arrival_time"
    t.string   "flight_no"
    t.text     "notes"
    t.integer  "event_group_id"
  end

  add_index "travel_segments", ["arrival_city"], :name => "travel_segments_arrival_city_index"
  add_index "travel_segments", ["arrival_time"], :name => "travel_segments_arrival_time_index"
  add_index "travel_segments", ["carrier"], :name => "travel_segments_carrier_index"
  add_index "travel_segments", ["departure_city"], :name => "travel_segments_departure_city_index"
  add_index "travel_segments", ["departure_time"], :name => "travel_segments_departure_time_index"
  add_index "travel_segments", ["event_group_id"], :name => "index_travel_segments_on_event_group_id"
  add_index "travel_segments", ["flight_no"], :name => "travel_segments_flight_no_index"
  add_index "travel_segments", ["year"], :name => "travel_segments_year_index"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "last_login"
    t.boolean  "system_admin"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "guid"
    t.boolean  "email_validated"
    t.boolean  "developer"
    t.string   "facebook_hash"
    t.string   "facebook_username"
  end

  add_index "users", ["guid"], :name => "index_users_on_guid", :unique => true

  create_table "view_columns", :force => true do |t|
    t.string   "view_id"
    t.string   "column_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "view_columns", ["column_id", "view_id"], :name => "view_columns_column_id"
  add_index "view_columns", ["view_id"], :name => "index_view_columns_on_view_id"

  create_table "views", :force => true do |t|
    t.string   "title"
    t.string   "ministry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default_view"
    t.string   "select_clause", :limit => 2000
    t.string   "tables_clause", :limit => 2000
  end

end
