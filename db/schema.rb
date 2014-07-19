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

ActiveRecord::Schema.define(version: 20140719065408) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "audit_entries", force: true do |t|
    t.integer  "actor_id",          null: false
    t.string   "actor_login"
    t.string   "actor_email"
    t.string   "service_class",     null: false
    t.string   "target_class",      null: false
    t.integer  "target_id",         null: false
    t.json     "target_attributes"
    t.json     "target_changes"
    t.json     "controller_params"
    t.datetime "created_at"
  end

  create_table "buckets", force: true do |t|
    t.string   "name",                   null: false
    t.integer  "row_order",  default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
  end

  add_index "buckets", ["team_id", "row_order"], name: "index_buckets_on_team_id_and_row_order", using: :btree

  create_table "issues", force: true do |t|
    t.string   "title",      null: false
    t.string   "owner",      null: false
    t.string   "repository", null: false
    t.integer  "number",     null: false
    t.integer  "state",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "assignee"
    t.binary   "labels"
  end

  add_index "issues", ["owner", "repository", "number"], name: "index_issues_on_owner_and_repository_and_number", unique: true, using: :btree

  create_table "prioritized_issues", force: true do |t|
    t.integer  "issue_id",                null: false
    t.integer  "bucket_id",               null: false
    t.integer  "row_order",   default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived_at"
  end

  add_index "prioritized_issues", ["bucket_id", "issue_id"], name: "index_prioritized_issues_on_bucket_id_and_issue_id", unique: true, using: :btree
  add_index "prioritized_issues", ["bucket_id", "row_order"], name: "index_prioritized_issues_on_bucket_id_and_row_order", using: :btree

  create_table "services", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "services", ["provider", "uid"], name: "index_services_on_provider_and_uid", unique: true, using: :btree
  add_index "services", ["user_id"], name: "index_services_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
  end

  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

end
