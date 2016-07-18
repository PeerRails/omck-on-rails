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

ActiveRecord::Schema.define(version: 20160707122952) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_tokens", force: :cascade do |t|
    t.string   "secret"
    t.integer  "user_id"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "api_tokens", ["secret"], name: "index_api_tokens_on_secret", using: :btree
  add_index "api_tokens", ["user_id"], name: "index_api_tokens_on_user_id", using: :btree

  create_table "channels", force: :cascade do |t|
    t.string   "channel",    limit: 255
    t.boolean  "live",                   default: false
    t.integer  "viewers",                default: 0,                            null: false
    t.string   "game",       limit: 255, default: "Boku no Pico"
    t.string   "streamer",   limit: 255, default: "McDwarf"
    t.string   "title",      limit: 255, default: "Boku wa Tomodachi ga Sekai"
    t.string   "service",    limit: 255, default: "twitch"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "official",               default: false
  end

  add_index "channels", ["channel"], name: "index_channels_on_channel", using: :btree

  create_table "keys", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "key",        limit: 255,                                        null: false
    t.string   "game",       limit: 255, default: "Boku no Pico",               null: false
    t.date     "expires",                default: '2099-01-01',                 null: false
    t.string   "streamer",   limit: 255, default: "McDwarf"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "guest",                  default: false
    t.string   "movie",      limit: 255, default: "Boku Wa Tomodachi Ga Sekai"
    t.integer  "created_by"
  end

  add_index "keys", ["created_by"], name: "index_keys_on_created_by", using: :btree
  add_index "keys", ["key"], name: "index_keys_on_key", using: :btree
  add_index "keys", ["user_id"], name: "index_keys_on_user_id", using: :btree

  create_table "playlists", force: :cascade do |t|
    t.integer  "video_id"
    t.integer  "status"
    t.string   "path"
    t.string   "thumb"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "playlists", ["video_id"], name: "index_playlists_on_video_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.inet     "ip"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "guest",      default: false
    t.date     "expires"
    t.string   "session_id"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree

  create_table "streams", force: :cascade do |t|
    t.integer  "key_id"
    t.integer  "user_id"
    t.integer  "channel_id"
    t.string   "game"
    t.string   "movie"
    t.string   "streamer"
    t.date     "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "streams", ["channel_id"], name: "index_streams_on_channel_id", using: :btree
  add_index "streams", ["key_id"], name: "index_streams_on_key_id", using: :btree
  add_index "streams", ["user_id"], name: "index_streams_on_user_id", using: :btree

  create_table "tweets", force: :cascade do |t|
    t.integer  "user_id",    default: 1, null: false
    t.text     "comment",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tweets", ["user_id"], name: "index_tweets_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "twitter_id",          limit: 255
    t.string   "screen_name",         limit: 255,                  null: false
    t.string   "profile_image_url",   limit: 255, default: ""
    t.string   "name",                limit: 255, default: "Anon"
    t.date     "login_last"
    t.inet     "last_ip"
    t.string   "access_token",        limit: 255
    t.string   "secret_token",        limit: 255
    t.integer  "gmod",                            default: 0,      null: false
    t.string   "hd_channel",          limit: 255, default: "0",    null: false
    t.integer  "streamer",                        default: 0,      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "remember_created_at"
    t.string   "remember_token"
    t.integer  "sign_in_count",                   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["twitter_id"], name: "index_users_on_twitter_id", using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "game",        default: "Boku no Pico", null: false
    t.integer  "user_id"
    t.integer  "key_id"
    t.string   "youtube_id"
    t.text     "description", default: "Boku no Pico"
    t.string   "token",                                null: false
    t.string   "path"
    t.boolean  "deleted",     default: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

end
