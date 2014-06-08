# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140608175825) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buckets", force: true do |t|
    t.string   "name",                   null: false
    t.integer  "row_order",  default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
  end

  create_table "issues", force: true do |t|
    t.string   "title",             null: false
    t.string   "github_owner",      null: false
    t.string   "github_repository", null: false
    t.integer  "github_id",         null: false
    t.integer  "state",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "assignee"
  end

  create_table "prioritized_issues", force: true do |t|
    t.integer  "issue_id",               null: false
    t.integer  "bucket_id",              null: false
    t.integer  "row_order",  default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "services", ["user_id"], name: "index_services_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
  end

end
