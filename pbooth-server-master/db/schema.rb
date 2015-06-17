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

ActiveRecord::Schema.define(version: 20150112184446) do

  create_table "events", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "gif_mode"
    t.integer  "photos_in_set"
    t.integer  "branded_image_width"
    t.integer  "branded_image_height"
    t.integer  "display_image_width"
    t.integer  "display_image_height"
    t.string   "copy_email_subject"
    t.text     "copy_email_body"
    t.text     "copy_social"
    t.integer  "print_image_width"
    t.integer  "print_image_height"
    t.string   "copy_twitter"
    t.boolean  "active"
    t.string   "smugmug_album"
    t.boolean  "multiple_orientations", default: false
    t.boolean  "option_smugmug"
    t.boolean  "option_facebook"
    t.boolean  "option_twitter"
    t.boolean  "option_email"
    t.boolean  "option_print"
  end

  create_table "photos", force: true do |t|
    t.integer  "photoset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "original_path"
    t.string   "display_path"
    t.string   "printing_path"
    t.string   "branded_path"
    t.boolean  "validated"
    t.string   "process_tag"
    t.datetime "taken_at"
  end

  create_table "photosets", force: true do |t|
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_path"
    t.string   "printing_path"
    t.string   "url"
    t.string   "branded_path"
    t.boolean  "validated"
    t.integer  "photos_count",  default: 0, null: false
  end

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "access_token"
    t.string   "access_token_secret"
  end

end
