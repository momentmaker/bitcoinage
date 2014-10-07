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

ActiveRecord::Schema.define(version: 20141007181937) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "price_points", force: true do |t|
    t.integer "date",  limit: 8, null: false
    t.float   "price",           null: false
  end

  create_table "transactions", force: true do |t|
    t.integer  "satoshi",    limit: 8, null: false
    t.integer  "price",                null: false
    t.integer  "fees",                 null: false
    t.date     "date",                 null: false
    t.string   "wallet"
    t.string   "trans_hash"
    t.integer  "user_id",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.string   "username",   null: false
    t.string   "name",       null: false
    t.string   "image"
    t.string   "url",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
