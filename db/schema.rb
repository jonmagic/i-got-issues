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

ActiveRecord::Schema.define(version: 20160127054900) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audit_entries", force: true do |t|
    t.integer  "team_id",               null: false
    t.string   "team_name"
    t.integer  "user_id",               null: false
    t.string   "user_login"
    t.integer  "action"
    t.integer  "issue_id"
    t.string   "issue_title"
    t.integer  "prioritized_issue_id"
    t.integer  "issue_start_position"
    t.integer  "issue_end_position"
    t.integer  "source_bucket_id"
    t.string   "source_bucket_name"
    t.integer  "target_bucket_id"
    t.string   "target_bucket_name"
    t.integer  "bucket_start_position"
    t.integer  "bucket_end_position"
    t.datetime "created_at"
  end

  add_index "audit_entries", ["created_at", "team_id"], name: "index_audit_entries_on_created_at_and_team_id", using: :btree

  create_table "buckets", force: true do |t|
    t.string   "name",                   null: false
    t.integer  "row_order",  default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
  end

  add_index "buckets", ["team_id", "row_order"], name: "index_buckets_on_team_id_and_row_order", using: :btree

  create_table "issues", force: true do |t|
    t.string   "title",                        null: false
    t.string   "owner",                        null: false
    t.string   "repository",                   null: false
    t.integer  "number",                       null: false
    t.integer  "state",                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "assignee"
    t.binary   "labels"
    t.boolean  "pull_request", default: false
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
