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

ActiveRecord::Schema.define(version: 20141017193149) do

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "avatar"
    t.integer  "group_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.boolean  "official",    default: false
  end

  add_index "groups", ["parent_id"], name: "index_groups_on_parent_id", using: :btree

  create_table "memberships", force: true do |t|
    t.string   "mode"
    t.integer  "approved",            default: 0
    t.integer  "moderate_members",    default: 0
    t.integer  "edit_infomation",     default: 0
    t.integer  "create_subgroups",    default: 0
    t.integer  "change_member_type",  default: 0
    t.integer  "approve_register",    default: 0
    t.integer  "make_group_official", default: 0
    t.integer  "make_event_official", default: 0
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "approved_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "api_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "avatar"
  end

end
