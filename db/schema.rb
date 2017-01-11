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

ActiveRecord::Schema.define(version: 20170110082042) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body",          limit: 65535
    t.string   "resource_id",   limit: 255,   null: false
    t.string   "resource_type", limit: 255,   null: false
    t.integer  "author_id",     limit: 4
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.integer  "sender_id",    limit: 4
    t.integer  "recipient_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gyms", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "contact_email",      limit: 255
    t.string   "phone",              limit: 255
    t.string   "location",           limit: 255
    t.integer  "user_id",            limit: 4
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.text     "hours_of_operation", limit: 65535
    t.string   "access_code",        limit: 255
    t.boolean  "active",                           default: false
    t.string   "subscription_id",    limit: 255
  end

  add_index "gyms", ["access_code"], name: "index_gyms_on_access_code", using: :btree
  add_index "gyms", ["user_id"], name: "index_gyms_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.text     "body",            limit: 65535
    t.integer  "conversation_id", limit: 4
    t.integer  "user_id",         limit: 4
    t.boolean  "read",                          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                     limit: 255,   default: "",     null: false
    t.string   "encrypted_password",        limit: 255,   default: "",     null: false
    t.string   "reset_password_token",      limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             limit: 4,     default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",        limit: 255
    t.string   "last_sign_in_ip",           limit: 255
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.string   "role",                      limit: 255,   default: "none"
    t.integer  "gym_id",                    limit: 4
    t.string   "image_file_name",           limit: 255
    t.string   "image_content_type",        limit: 255
    t.integer  "image_file_size",           limit: 4
    t.datetime "image_updated_at"
    t.text     "hours_in_gym",              limit: 65535
    t.string   "name",                      limit: 255
    t.string   "workout_level",             limit: 255
    t.string   "gender",                    limit: 255
    t.string   "auth_token",                limit: 255
    t.string   "workout_time",              limit: 255
    t.string   "gender_match",              limit: 255
    t.string   "description",               limit: 255
    t.string   "second_image_file_name",    limit: 255
    t.string   "second_image_content_type", limit: 255
    t.integer  "second_image_file_size",    limit: 4
    t.datetime "second_image_updated_at"
    t.string   "third_image_file_name",     limit: 255
    t.string   "third_image_content_type",  limit: 255
    t.integer  "third_image_file_size",     limit: 4
    t.datetime "third_image_updated_at"
    t.string   "device_token",              limit: 255
    t.string   "device_type",               limit: 255
    t.string   "stripeid",                  limit: 255
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["gym_id"], name: "index_users_on_gym_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.integer "role_id", limit: 4
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  add_foreign_key "users", "gyms"
end
