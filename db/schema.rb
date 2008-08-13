# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20) do

  create_table "categories", :force => true do |t|
    t.integer "parent_id", :limit => 11
  end

  create_table "countries", :force => true do |t|
    t.string "name"
    t.string "iso_3166"
  end

  create_table "countries_movies", :id => false, :force => true do |t|
    t.integer  "country_id", :limit => 11, :null => false
    t.integer  "movie_id",   :limit => 11, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", :force => true do |t|
    t.integer  "role",       :limit => 11,                :null => false
    t.integer  "movie_id",   :limit => 11,                :null => false
    t.integer  "person_id",  :limit => 11,                :null => false
    t.integer  "number",     :limit => 11, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id",    :limit => 11, :null => false
    t.integer  "friend_id",  :limit => 11, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres", :force => true do |t|
    t.string   "name",                     :null => false
    t.integer  "omdb",       :limit => 11, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres_movies", :id => false, :force => true do |t|
    t.integer  "genre_id",   :limit => 11, :null => false
    t.integer  "movie_id",   :limit => 11, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :force => true do |t|
    t.integer  "omdb",       :limit => 11, :null => false
    t.string   "name",                     :null => false
    t.string   "iso_639_1",                :null => false
    t.string   "iso_639_2",                :null => false
    t.string   "iso_639_3",                :null => false
    t.string   "iso_3166"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages_rips", :id => false, :force => true do |t|
    t.integer  "language_id", :limit => 11, :null => false
    t.integer  "rip_id",      :limit => 11, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movies", :force => true do |t|
    t.integer  "omdb",        :limit => 11, :null => false
    t.string   "title",                     :null => false
    t.text     "description"
    t.integer  "year",        :limit => 11
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parts", :force => true do |t|
    t.integer  "rip_id",               :limit => 11
    t.string   "mrokhash",                                              :null => false
    t.integer  "number",               :limit => 11, :default => 0
    t.integer  "audio_bit_rate",       :limit => 11
    t.integer  "audio_channels",       :limit => 11
    t.integer  "audio_sample_rate",    :limit => 11
    t.integer  "video_frame_rate",     :limit => 11
    t.integer  "duration",             :limit => 11
    t.integer  "filesize",             :limit => 11
    t.string   "audio_encoding"
    t.string   "video_encoding"
    t.string   "video_resolution"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "md5"
    t.string   "sha1"
    t.boolean  "movie_file_meta_data",               :default => false
    t.string   "container"
  end

  create_table "parts_users", :id => false, :force => true do |t|
    t.integer  "part_id",    :limit => 11, :null => false
    t.integer  "user_id",    :limit => 11, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.integer  "omdb",       :limit => 11, :null => false
    t.string   "name",                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "rip_id",     :limit => 11, :null => false
    t.integer  "user_id",    :limit => 11, :null => false
    t.integer  "rating",     :limit => 11, :null => false
    t.integer  "type_id",    :limit => 11, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rip_versions", :force => true do |t|
    t.integer  "rip_id",          :limit => 11
    t.integer  "version",         :limit => 11
    t.integer  "movie_id",        :limit => 11
    t.integer  "editor_id",       :limit => 11
    t.integer  "type_id",         :limit => 11
    t.string   "releaser"
    t.date     "released_at"
    t.text     "release_comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "part_ids"
    t.string   "language_ids"
    t.string   "subtitle_ids"
  end

  create_table "rips", :force => true do |t|
    t.integer  "movie_id",        :limit => 11, :null => false
    t.integer  "editor_id",       :limit => 11, :null => false
    t.integer  "type_id",         :limit => 11
    t.integer  "version",         :limit => 11
    t.string   "releaser"
    t.date     "released_at"
    t.text     "release_comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rips_subtitles", :id => false, :force => true do |t|
    t.integer  "language_id", :limit => 11, :null => false
    t.integer  "rip_id",      :limit => 11, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                              :null => false
    t.string   "hashed_password",                   :null => false
    t.string   "email"
    t.string   "salt",                              :null => false
    t.boolean  "public_rips",     :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
