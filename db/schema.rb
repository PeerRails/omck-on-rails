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

ActiveRecord::Schema.define(version: 20161026211656) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_tokens", force: :cascade do |t|
    t.string   "secret"
    t.integer  "user_id"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "client_id"
    t.index ["client_id"], name: "index_api_tokens_on_client_id", using: :btree
    t.index ["secret"], name: "index_api_tokens_on_secret", using: :btree
    t.index ["user_id"], name: "index_api_tokens_on_user_id", using: :btree
  end

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
    t.index ["channel"], name: "index_channels_on_channel", using: :btree
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name",        default: "Dwarf"
    t.string   "email"
    t.string   "password"
    t.boolean  "admin",       default: false
    t.boolean  "streamer",    default: false
    t.boolean  "bot",         default: false
    t.datetime "verified"
    t.datetime "remember_at"
    t.datetime "last_login"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["admin"], name: "index_clients_on_admin", using: :btree
    t.index ["bot"], name: "index_clients_on_bot", using: :btree
    t.index ["email"], name: "index_clients_on_email", using: :btree
    t.index ["password"], name: "index_clients_on_password", using: :btree
    t.index ["streamer"], name: "index_clients_on_streamer", using: :btree
  end

  create_table "keys", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "key",        limit: 255,                                        null: false
    t.string   "game",       limit: 255, default: "Boku no Pico",               null: false
    t.datetime "expires",                default: '2099-01-01 00:00:00',        null: false
    t.string   "streamer",   limit: 255, default: "McDwarf"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "guest",                  default: false
    t.string   "movie",      limit: 255, default: "Boku Wa Tomodachi Ga Sekai"
    t.integer  "created_by"
    t.integer  "client_id"
    t.index ["client_id"], name: "index_keys_on_client_id", using: :btree
    t.index ["created_by"], name: "index_keys_on_created_by", using: :btree
    t.index ["key"], name: "index_keys_on_key", using: :btree
    t.index ["user_id"], name: "index_keys_on_user_id", using: :btree
  end

  create_table "playlists", force: :cascade do |t|
    t.integer  "video_id"
    t.integer  "status"
    t.string   "path"
    t.string   "thumb"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["video_id"], name: "index_playlists_on_video_id", using: :btree
  end

  create_table "sessions", force: :cascade do |t|
    t.inet     "ip"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "guest",      default: false
    t.datetime "expires"
    t.string   "session_id"
    t.integer  "client_id"
    t.index ["client_id"], name: "index_sessions_on_client_id", using: :btree
    t.index ["session_id"], name: "index_sessions_on_session_id", using: :btree
  end

  create_table "streams", force: :cascade do |t|
    t.integer  "key_id",     null: false
    t.integer  "user_id",    null: false
    t.integer  "channel_id", null: false
    t.string   "game"
    t.string   "movie"
    t.string   "streamer"
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "client_id"
    t.index ["channel_id"], name: "index_streams_on_channel_id", using: :btree
    t.index ["client_id"], name: "index_streams_on_client_id", using: :btree
    t.index ["key_id"], name: "index_streams_on_key_id", using: :btree
    t.index ["user_id"], name: "index_streams_on_user_id", using: :btree
  end

  create_table "tweets", force: :cascade do |t|
    t.integer  "user_id",    default: 1, null: false
    t.text     "comment",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
    t.index ["client_id"], name: "index_tweets_on_client_id", using: :btree
    t.index ["user_id"], name: "index_tweets_on_user_id", using: :btree
  end

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
    t.index ["twitter_id"], name: "index_users_on_twitter_id", using: :btree
  end

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
    t.integer  "client_id"
    t.integer  "stream_id"
    t.index ["client_id"], name: "index_videos_on_client_id", using: :btree
  end

end
