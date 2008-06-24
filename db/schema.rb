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

ActiveRecord::Schema.define(:version => 6) do

  create_table "location_groups", :force => true do |t|
    t.string  "name"
    t.string  "type"
    t.integer "parent_id"
    t.string  "alias_type"
    t.integer "alias_id"
    t.integer "ministry_id"
  end

  create_table "locations", :force => true do |t|
    t.string  "name"
    t.integer "parent_id"
  end

  create_table "ministries", :force => true do |t|
    t.string  "name"
    t.integer "parent_id"
    t.integer "children_count"
  end

  create_table "permissions", :force => true do |t|
    t.string  "name"
    t.integer "parent_id"
  end

  create_table "viewer_assignments", :force => true do |t|
    t.integer "location_id"
    t.integer "ministry_id"
    t.integer "permission_id"
    t.string  "custom"
  end

end
