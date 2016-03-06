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

ActiveRecord::Schema.define(version: 20160305235831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attractions", force: :cascade do |t|
    t.text     "name"
    t.string   "lat"
    t.string   "long"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "language_id"
    t.string   "currency"
    t.integer  "quote_id"
    t.string   "bestseason"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "attractions", ["language_id"], name: "index_attractions_on_language_id", using: :btree
  add_index "attractions", ["quote_id"], name: "index_attractions_on_quote_id", using: :btree

  create_table "attractions_tours", id: false, force: :cascade do |t|
    t.integer "tour_id",       null: false
    t.integer "attraction_id", null: false
  end

  add_index "attractions_tours", ["attraction_id", "tour_id"], name: "index_attractions_tours_on_attraction_id_and_tour_id", using: :btree
  add_index "attractions_tours", ["tour_id", "attraction_id"], name: "index_attractions_tours_on_tour_id_and_attraction_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "confirmeds", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "confirmeds", ["user_id"], name: "index_confirmeds_on_user_id", using: :btree

  create_table "includeds", force: :cascade do |t|
    t.integer  "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "includeds", ["service_id"], name: "index_includeds_on_service_id", using: :btree

  create_table "languages", force: :cascade do |t|
    t.string   "name"
    t.string   "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.integer  "user_id",      null: false
    t.integer  "organizer_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "members", ["organizer_id"], name: "index_members_on_organizer_id", using: :btree
  add_index "members", ["user_id"], name: "index_members_on_user_id", using: :btree

  create_table "nonincludeds", force: :cascade do |t|
    t.integer  "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "nonincludeds", ["service_id"], name: "index_nonincludeds_on_service_id", using: :btree

  create_table "organizers", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "member_id"
    t.integer  "rating"
    t.integer  "user_id",     null: false
    t.integer  "where_id"
    t.string   "email"
    t.string   "website"
    t.string   "facebook"
    t.string   "twitter"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "organizers", ["member_id"], name: "index_organizers_on_member_id", using: :btree
  add_index "organizers", ["user_id"], name: "index_organizers_on_user_id", using: :btree
  add_index "organizers", ["where_id"], name: "index_organizers_on_where_id", using: :btree

  create_table "pictures", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.string   "caption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quotes", force: :cascade do |t|
    t.string   "content"
    t.string   "url"
    t.string   "author"
    t.string   "sitename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "tour_id",    null: false
    t.integer  "rating"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reviews", ["tour_id"], name: "index_reviews_on_tour_id", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscribers", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags_tours", id: false, force: :cascade do |t|
    t.integer "tour_id", null: false
    t.integer "tag_id",  null: false
  end

  add_index "tags_tours", ["tag_id", "tour_id"], name: "index_tags_tours_on_tag_id_and_tour_id", using: :btree
  add_index "tags_tours", ["tour_id", "tag_id"], name: "index_tags_tours_on_tour_id_and_tag_id", using: :btree

  create_table "tours", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "rating"
    t.integer  "value"
    t.string   "currency"
    t.integer  "organizer_id",   null: false
    t.datetime "start"
    t.datetime "end"
    t.string   "picture"
    t.integer  "availability"
    t.integer  "minimum"
    t.integer  "maximum"
    t.integer  "picture_id",     null: false
    t.integer  "difficulty"
    t.integer  "where_id",       null: false
    t.string   "address"
    t.integer  "user_id",        null: false
    t.integer  "service_id",     null: false
    t.integer  "included_id",    null: false
    t.integer  "nonincluded_id", null: false
    t.integer  "category_id",    null: false
    t.integer  "tag_id"
    t.integer  "attraction_id"
    t.string   "privacy"
    t.string   "meetingpoint"
    t.integer  "confirmed_id"
    t.integer  "language_id"
    t.integer  "review_id"
    t.string   "verified"
    t.string   "status"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "tours", ["attraction_id"], name: "index_tours_on_attraction_id", using: :btree
  add_index "tours", ["category_id"], name: "index_tours_on_category_id", using: :btree
  add_index "tours", ["confirmed_id"], name: "index_tours_on_confirmed_id", using: :btree
  add_index "tours", ["included_id"], name: "index_tours_on_included_id", using: :btree
  add_index "tours", ["language_id"], name: "index_tours_on_language_id", using: :btree
  add_index "tours", ["nonincluded_id"], name: "index_tours_on_nonincluded_id", using: :btree
  add_index "tours", ["organizer_id"], name: "index_tours_on_organizer_id", using: :btree
  add_index "tours", ["picture_id"], name: "index_tours_on_picture_id", using: :btree
  add_index "tours", ["review_id"], name: "index_tours_on_review_id", using: :btree
  add_index "tours", ["service_id"], name: "index_tours_on_service_id", using: :btree
  add_index "tours", ["tag_id"], name: "index_tours_on_tag_id", using: :btree
  add_index "tours", ["user_id"], name: "index_tours_on_user_id", using: :btree
  add_index "tours", ["where_id"], name: "index_tours_on_where_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "wheres", force: :cascade do |t|
    t.string   "name"
    t.string   "lat"
    t.string   "long"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "attractions", "languages"
  add_foreign_key "attractions", "quotes"
  add_foreign_key "confirmeds", "users"
  add_foreign_key "includeds", "services"
  add_foreign_key "members", "users"
  add_foreign_key "nonincludeds", "services"
  add_foreign_key "organizers", "members"
  add_foreign_key "organizers", "users"
  add_foreign_key "organizers", "wheres"
  add_foreign_key "reviews", "tours"
  add_foreign_key "reviews", "users"
  add_foreign_key "tours", "attractions"
  add_foreign_key "tours", "confirmeds"
  add_foreign_key "tours", "includeds"
  add_foreign_key "tours", "languages"
  add_foreign_key "tours", "nonincludeds"
  add_foreign_key "tours", "organizers"
  add_foreign_key "tours", "pictures"
  add_foreign_key "tours", "reviews"
  add_foreign_key "tours", "tags"
  add_foreign_key "tours", "users"
  add_foreign_key "tours", "wheres"
end
