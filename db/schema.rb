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

ActiveRecord::Schema.define(version: 20151110094642) do

  create_table "categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "this_id",        limit: 4
    t.integer "parent_id",      limit: 4
    t.integer "lft",            limit: 4
    t.integer "rgt",            limit: 4
    t.integer "depth",          limit: 4,   default: 0
    t.integer "children_count", limit: 4,   default: 0
  end

  add_index "profiles", ["parent_id", "lft", "rgt", "depth"], name: "index_profiles_on_parent_id_and_lft_and_rgt_and_depth", using: :btree

  create_table "roles", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.string   "role",        limit: 255
    t.integer  "category_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "roles", ["category_id"], name: "index_roles_on_category_id", using: :btree
  add_index "roles", ["user_id"], name: "index_roles_on_user_id", using: :btree

  create_table "skills", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.integer  "category_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "author_id",   limit: 4
  end

  add_index "skills", ["author_id"], name: "index_skills_on_author_id", using: :btree
  add_index "skills", ["category_id"], name: "index_skills_on_category_id", using: :btree

  create_table "skills_tags", id: false, force: :cascade do |t|
    t.integer "tag_id",   limit: 4, null: false
    t.integer "skill_id", limit: 4, null: false
  end

  add_index "skills_tags", ["skill_id", "tag_id"], name: "index_skills_tags_on_skill_id_and_tag_id", using: :btree
  add_index "skills_tags", ["tag_id", "skill_id"], name: "index_skills_tags_on_tag_id_and_skill_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,   default: "",    null: false
    t.string   "encrypted_password",     limit: 255,   default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                                default: false
    t.datetime "archived_at"
    t.boolean  "customer",                             default: false
    t.boolean  "worker",                               default: false
    t.string   "username",               limit: 255
    t.string   "fullname",               limit: 255
    t.integer  "profile_id",             limit: 4
    t.text     "bio",                    limit: 65535
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["profile_id"], name: "index_users_on_profile_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "roles", "categories"
  add_foreign_key "roles", "users"
  add_foreign_key "skills", "categories"
  add_foreign_key "skills", "users", column: "author_id"
  add_foreign_key "users", "profiles"
end
