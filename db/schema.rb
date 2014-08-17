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

ActiveRecord::Schema.define(version: 20140728134907) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "channels", force: true do |t|
    t.string   "channel"
    t.boolean  "live",       default: false
    t.integer  "viewers",    default: 0,                            null: false
    t.string   "game",       default: "Boku no Pico",               null: false
    t.string   "streamer",   default: "McDwarf"
    t.string   "title",      default: "Boku wa Tomodachi ga Sekai"
    t.string   "service",    default: "twitch"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keys", force: true do |t|
    t.integer  "uid"
    t.string   "key"
    t.string   "game"
    t.date     "expires"
    t.string   "streamer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "guest"
    t.string   "movie",      default: "Boku Wa Tomodachi Ga Sekai"
  end

  add_index "keys", ["key"], name: "index_keys_on_key", using: :btree

  create_table "tweets", force: true do |t|
    t.integer  "uid",        default: 1,             null: false
    t.string   "author",     default: "Wombo Combo"
    t.text     "comment",                            null: false
    t.integer  "type",       default: 2,             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tweets", ["uid"], name: "index_tweets_on_uid", using: :btree

  create_table "users", force: true do |t|
    t.string   "uid"
    t.string   "screen_name",                        null: false
    t.string   "profile_image_url", default: ""
    t.string   "name",              default: "Anon"
    t.date     "login_last"
    t.inet     "last_ip"
    t.string   "access_token"
    t.string   "secret_token"
    t.string   "hd_channel",        default: "0",    null: false
    t.string   "twitch",            default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gmod",              default: 0,      null: false
    t.integer  "streamer",          default: 0,      null: false
  end

end
