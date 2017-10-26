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

ActiveRecord::Schema.define(version: 20171025214956) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attractions", force: :cascade do |t|
    t.string   "name"
    t.string   "text"
    t.string   "photo"
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

  create_table "attractions_wheres", id: false, force: :cascade do |t|
    t.integer "where_id",      null: false
    t.integer "attraction_id", null: false
  end

  add_index "attractions_wheres", ["attraction_id", "where_id"], name: "index_attractions_wheres_on_attraction_id_and_where_id", using: :btree
  add_index "attractions_wheres", ["where_id", "attraction_id"], name: "index_attractions_wheres_on_where_id_and_attraction_id", using: :btree

  create_table "backgrounds", force: :cascade do |t|
    t.string   "name"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "backgrounds_wheres", id: false, force: :cascade do |t|
    t.integer "background_id", null: false
    t.integer "where_id",      null: false
  end

  add_index "backgrounds_wheres", ["background_id", "where_id"], name: "index_backgrounds_wheres_on_background_id_and_where_id", using: :btree
  add_index "backgrounds_wheres", ["where_id", "background_id"], name: "index_backgrounds_wheres_on_where_id_and_background_id", using: :btree

  create_table "bank_accounts", force: :cascade do |t|
    t.string   "bank_number"
    t.string   "agency_number"
    t.string   "agency_check_number"
    t.string   "account_number"
    t.string   "account_check_number"
    t.string   "bank_type"
    t.string   "doc_type"
    t.string   "doc_number"
    t.string   "fullname"
    t.boolean  "active"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "marketplace_id"
    t.string   "own_id"
  end

  add_index "bank_accounts", ["marketplace_id"], name: "index_bank_accounts_on_marketplace_id", using: :btree

  create_table "bank_accounts_marketplaces", id: false, force: :cascade do |t|
    t.integer "marketplace_id",  null: false
    t.integer "bank_account_id", null: false
  end

  add_index "bank_accounts_marketplaces", ["bank_account_id", "marketplace_id"], name: "bank_account_id_mktplace", using: :btree
  add_index "bank_accounts_marketplaces", ["marketplace_id", "bank_account_id"], name: "mktplace_id_bank_account", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "collaborators", force: :cascade do |t|
    t.integer  "marketplace_id"
    t.decimal  "percent",        precision: 5, scale: 2
    t.string   "transfer"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "collaborators", ["marketplace_id"], name: "index_collaborators_on_marketplace_id", using: :btree

  create_table "collaborators_tours", id: false, force: :cascade do |t|
    t.integer "tour_id",         null: false
    t.integer "collaborator_id", null: false
  end

  add_index "collaborators_tours", ["collaborator_id", "tour_id"], name: "index_collaborators_tours_on_collaborator_id_and_tour_id", using: :btree
  add_index "collaborators_tours", ["tour_id", "collaborator_id"], name: "index_collaborators_tours_on_tour_id_and_collaborator_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "title"
    t.string   "comment"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "parent_id"
  end

  add_index "comments", ["parent_id"], name: "index_comments_on_parent_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "comments_guidebooks", id: false, force: :cascade do |t|
    t.integer "comment_id",   null: false
    t.integer "guidebook_id", null: false
  end

  add_index "comments_guidebooks", ["comment_id", "guidebook_id"], name: "index_comments_guidebooks_on_comment_id_and_guidebook_id", using: :btree
  add_index "comments_guidebooks", ["guidebook_id", "comment_id"], name: "index_comments_guidebooks_on_guidebook_id_and_comment_id", using: :btree

  create_table "confirmeds", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "confirmeds", ["user_id"], name: "index_confirmeds_on_user_id", using: :btree

  create_table "confirmeds_tours", id: false, force: :cascade do |t|
    t.integer "confirmed_id", null: false
    t.integer "tour_id",      null: false
  end

  add_index "confirmeds_tours", ["confirmed_id", "tour_id"], name: "index_confirmeds_tours_on_confirmed_id_and_tour_id", using: :btree
  add_index "confirmeds_tours", ["tour_id", "confirmed_id"], name: "index_confirmeds_tours_on_tour_id_and_confirmed_id", using: :btree

  create_table "customers", force: :cascade do |t|
    t.string   "token"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "customers", ["user_id"], name: "index_customers_on_user_id", using: :btree

  create_table "destinations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "downloaded"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "destinations", ["user_id"], name: "index_destinations_on_user_id", using: :btree

  create_table "forms", force: :cascade do |t|
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "guidebooks", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "rating"
    t.integer  "value"
    t.string   "currency"
    t.integer  "organizer_id",                      null: false
    t.integer  "user_id",                           null: false
    t.string   "privacy"
    t.string   "verified"
    t.string   "status"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "category_id"
    t.string   "included",             default: [],              array: true
    t.string   "nonincluded",          default: [],              array: true
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "destination_id"
    t.integer  "form_id"
    t.string   "photo"
  end

  add_index "guidebooks", ["category_id"], name: "index_guidebooks_on_category_id", using: :btree
  add_index "guidebooks", ["destination_id"], name: "index_guidebooks_on_destination_id", using: :btree
  add_index "guidebooks", ["form_id"], name: "index_guidebooks_on_form_id", using: :btree
  add_index "guidebooks", ["organizer_id"], name: "index_guidebooks_on_organizer_id", using: :btree
  add_index "guidebooks", ["user_id"], name: "index_guidebooks_on_user_id", using: :btree

  create_table "guidebooks_languages", id: false, force: :cascade do |t|
    t.integer "language_id",  null: false
    t.integer "guidebook_id", null: false
  end

  add_index "guidebooks_languages", ["guidebook_id", "language_id"], name: "index_guidebooks_languages_on_guidebook_id_and_language_id", using: :btree
  add_index "guidebooks_languages", ["language_id", "guidebook_id"], name: "index_guidebooks_languages_on_language_id_and_guidebook_id", using: :btree

  create_table "guidebooks_orders", id: false, force: :cascade do |t|
    t.integer "guidebook_id", null: false
    t.integer "order_id",     null: false
  end

  add_index "guidebooks_orders", ["guidebook_id", "order_id"], name: "index_guidebooks_orders_on_guidebook_id_and_order_id", using: :btree
  add_index "guidebooks_orders", ["order_id", "guidebook_id"], name: "index_guidebooks_orders_on_order_id_and_guidebook_id", using: :btree

  create_table "guidebooks_packages", id: false, force: :cascade do |t|
    t.integer "package_id",   null: false
    t.integer "guidebook_id", null: false
  end

  add_index "guidebooks_packages", ["guidebook_id", "package_id"], name: "index_guidebooks_packages_on_guidebook_id_and_package_id", using: :btree
  add_index "guidebooks_packages", ["package_id", "guidebook_id"], name: "index_guidebooks_packages_on_package_id_and_guidebook_id", using: :btree

  create_table "guidebooks_tags", id: false, force: :cascade do |t|
    t.integer "tag_id",       null: false
    t.integer "guidebook_id", null: false
  end

  add_index "guidebooks_tags", ["guidebook_id", "tag_id"], name: "index_guidebooks_tags_on_guidebook_id_and_tag_id", using: :btree
  add_index "guidebooks_tags", ["tag_id", "guidebook_id"], name: "index_guidebooks_tags_on_tag_id_and_guidebook_id", using: :btree

  create_table "guidebooks_wheres", id: false, force: :cascade do |t|
    t.integer "where_id",     null: false
    t.integer "guidebook_id", null: false
  end

  add_index "guidebooks_wheres", ["guidebook_id", "where_id"], name: "index_guidebooks_wheres_on_guidebook_id_and_where_id", using: :btree
  add_index "guidebooks_wheres", ["where_id", "guidebook_id"], name: "index_guidebooks_wheres_on_where_id_and_guidebook_id", using: :btree

  create_table "languages", force: :cascade do |t|
    t.string   "name"
    t.string   "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "languages_tours", id: false, force: :cascade do |t|
    t.integer "language_id", null: false
    t.integer "tour_id",     null: false
  end

  add_index "languages_tours", ["language_id", "tour_id"], name: "index_languages_tours_on_language_id_and_tour_id", using: :btree
  add_index "languages_tours", ["tour_id", "language_id"], name: "index_languages_tours_on_tour_id_and_language_id", using: :btree

  create_table "maily_herald_dispatches", force: :cascade do |t|
    t.string   "type",                                       null: false
    t.integer  "sequence_id"
    t.integer  "list_id",                                    null: false
    t.text     "conditions"
    t.text     "start_at"
    t.string   "mailer_name"
    t.string   "name",                                       null: false
    t.string   "title"
    t.string   "subject"
    t.string   "from"
    t.string   "state",                 default: "disabled"
    t.text     "template"
    t.integer  "absolute_delay"
    t.integer  "period"
    t.boolean  "override_subscription"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "maily_herald_dispatches", ["name"], name: "index_maily_herald_dispatches_on_name", unique: true, using: :btree

  create_table "maily_herald_lists", force: :cascade do |t|
    t.string "name",         null: false
    t.string "title"
    t.string "context_name"
  end

  create_table "maily_herald_logs", force: :cascade do |t|
    t.integer  "entity_id",     null: false
    t.string   "entity_type",   null: false
    t.string   "entity_email"
    t.integer  "mailing_id"
    t.string   "status",        null: false
    t.text     "data"
    t.datetime "processing_at"
  end

  create_table "maily_herald_subscriptions", force: :cascade do |t|
    t.integer  "entity_id",                    null: false
    t.integer  "list_id",                      null: false
    t.string   "entity_type",                  null: false
    t.string   "token",                        null: false
    t.text     "settings"
    t.text     "data"
    t.boolean  "active",       default: false, null: false
    t.datetime "delivered_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "marketplaces", force: :cascade do |t|
    t.integer  "organizer_id"
    t.integer  "bank_account_id"
    t.boolean  "active"
    t.string   "person_name"
    t.string   "person_lastname"
    t.string   "document_type"
    t.string   "document_number"
    t.string   "id_number"
    t.string   "id_type"
    t.string   "id_issuer"
    t.string   "id_issuerdate"
    t.date     "birthDate"
    t.string   "street"
    t.string   "street_number"
    t.string   "complement"
    t.string   "district"
    t.string   "zipcode"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "token"
    t.string   "account_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "business",               default: false
    t.string   "company_city"
    t.string   "company_country"
    t.string   "company_street"
    t.string   "compcompany_complement"
    t.string   "company_state"
    t.string   "company_zipcode"
    t.date     "terms_accepted"
    t.string   "terms_ip"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "terms",                  default: false
  end

  add_index "marketplaces", ["bank_account_id"], name: "index_marketplaces_on_bank_account_id", using: :btree
  add_index "marketplaces", ["organizer_id"], name: "index_marketplaces_on_organizer_id", using: :btree

  create_table "marketplaces_payment_types", id: false, force: :cascade do |t|
    t.integer "marketplace_id",  null: false
    t.integer "payment_type_id", null: false
  end

  add_index "marketplaces_payment_types", ["marketplace_id", "payment_type_id"], name: "marketplace_payment", using: :btree
  add_index "marketplaces_payment_types", ["payment_type_id", "marketplace_id"], name: "payment_marketplace", using: :btree

  create_table "members", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "members", ["user_id"], name: "index_members_on_user_id", using: :btree

  create_table "members_organizers", id: false, force: :cascade do |t|
    t.integer "organizer_id", null: false
    t.integer "member_id",    null: false
  end

  add_index "members_organizers", ["member_id", "organizer_id"], name: "index_members_organizers_on_member_id_and_organizer_id", using: :btree
  add_index "members_organizers", ["organizer_id", "member_id"], name: "index_members_organizers_on_organizer_id_and_member_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "source_id"
    t.string   "own_id"
    t.integer  "tour_id"
    t.integer  "user_id"
    t.string   "status"
    t.text     "status_history", default: [],                         array: true
    t.string   "payment"
    t.integer  "price"
    t.integer  "discount"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "amount",         default: 1
    t.integer  "final_price"
    t.string   "payment_method", default: "CREDIT_CARD"
    t.integer  "liquid"
    t.integer  "fee"
    t.string   "destination"
    t.string   "source"
    t.integer  "guidebook_id"
  end

  add_index "orders", ["guidebook_id"], name: "index_orders_on_guidebook_id", using: :btree
  add_index "orders", ["tour_id"], name: "index_orders_on_tour_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "orders_tours", id: false, force: :cascade do |t|
    t.integer "tour_id",  null: false
    t.integer "order_id", null: false
  end

  add_index "orders_tours", ["order_id", "tour_id"], name: "index_orders_tours_on_order_id_and_tour_id", using: :btree
  add_index "orders_tours", ["tour_id", "order_id"], name: "index_orders_tours_on_tour_id_and_order_id", using: :btree

  create_table "orders_users", id: false, force: :cascade do |t|
    t.integer "user_id",  null: false
    t.integer "order_id", null: false
  end

  create_table "organizers", force: :cascade do |t|
    t.string   "name"
    t.string   "logo"
    t.string   "cover"
    t.string   "description"
    t.string   "fulldesc"
    t.integer  "member_id"
    t.integer  "rating"
    t.integer  "user_id",                              null: false
    t.string   "email"
    t.string   "website"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "instagram"
    t.string   "phone"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.boolean  "market_place_active",  default: false
    t.integer  "marketplace_id"
    t.string   "status"
    t.string   "policy",               default: [],                 array: true
    t.integer  "percent",              default: 3
    t.string   "invite_token"
  end

  add_index "organizers", ["marketplace_id"], name: "index_organizers_on_marketplace_id", using: :btree
  add_index "organizers", ["member_id"], name: "index_organizers_on_member_id", using: :btree
  add_index "organizers", ["user_id"], name: "index_organizers_on_user_id", using: :btree

  create_table "organizers_wheres", id: false, force: :cascade do |t|
    t.integer "organizer_id", null: false
    t.integer "where_id",     null: false
  end

  add_index "organizers_wheres", ["organizer_id", "where_id"], name: "index_organizers_wheres_on_organizer_id_and_where_id", using: :btree
  add_index "organizers_wheres", ["where_id", "organizer_id"], name: "index_organizers_wheres_on_where_id_and_organizer_id", using: :btree

  create_table "packages", force: :cascade do |t|
    t.text     "name"
    t.integer  "value"
    t.text     "included",                            default: [],              array: true
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.decimal  "percent",     precision: 5, scale: 2
    t.text     "description"
  end

  create_table "packages_tours", id: false, force: :cascade do |t|
    t.integer "tour_id",    null: false
    t.integer "package_id", null: false
  end

  add_index "packages_tours", ["package_id", "tour_id"], name: "index_packages_tours_on_package_id_and_tour_id", using: :btree
  add_index "packages_tours", ["tour_id", "package_id"], name: "index_packages_tours_on_tour_id_and_package_id", using: :btree

  create_table "parents", force: :cascade do |t|
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "parents", ["comment_id"], name: "index_parents_on_comment_id", using: :btree

  create_table "payment_types", force: :cascade do |t|
    t.integer  "marketplace_id"
    t.string   "type_name"
    t.string   "email"
    t.string   "token"
    t.string   "appId"
    t.string   "auth"
    t.string   "key"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "payment_types", ["marketplace_id"], name: "index_payment_types_on_marketplace_id", using: :btree

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

  create_table "reviews_tours", id: false, force: :cascade do |t|
    t.integer "review_id", null: false
    t.integer "tour_id",   null: false
  end

  add_index "reviews_tours", ["review_id", "tour_id"], name: "index_reviews_tours_on_review_id_and_tour_id", using: :btree
  add_index "reviews_tours", ["tour_id", "review_id"], name: "index_reviews_tours_on_tour_id_and_review_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

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

  create_table "tour_pictures", force: :cascade do |t|
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "tour_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "tour_pictures", ["tour_id"], name: "index_tour_pictures_on_tour_id", using: :btree

  create_table "tours", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "rating"
    t.integer  "value"
    t.string   "currency"
    t.integer  "organizer_id",                         null: false
    t.datetime "start"
    t.datetime "end"
    t.string   "photo"
    t.integer  "availability"
    t.integer  "minimum"
    t.integer  "maximum"
    t.integer  "difficulty"
    t.string   "address"
    t.integer  "user_id",                              null: false
    t.text     "included",             default: [],                 array: true
    t.text     "nonincluded",          default: [],                 array: true
    t.text     "take",                 default: [],                 array: true
    t.text     "goodtoknow",           default: [],                 array: true
    t.integer  "category_id"
    t.integer  "tag_id"
    t.integer  "attraction_id"
    t.string   "privacy"
    t.string   "meetingpoint"
    t.integer  "confirmed_id"
    t.integer  "language_id"
    t.integer  "review_id"
    t.string   "verified"
    t.string   "status"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "reserved",             default: 0
    t.string   "link"
    t.boolean  "removed"
    t.boolean  "value_chosen_by_user", default: false
  end

  add_index "tours", ["attraction_id"], name: "index_tours_on_attraction_id", using: :btree
  add_index "tours", ["category_id"], name: "index_tours_on_category_id", using: :btree
  add_index "tours", ["confirmed_id"], name: "index_tours_on_confirmed_id", using: :btree
  add_index "tours", ["language_id"], name: "index_tours_on_language_id", using: :btree
  add_index "tours", ["organizer_id"], name: "index_tours_on_organizer_id", using: :btree
  add_index "tours", ["review_id"], name: "index_tours_on_review_id", using: :btree
  add_index "tours", ["tag_id"], name: "index_tours_on_tag_id", using: :btree
  add_index "tours", ["user_id"], name: "index_tours_on_user_id", using: :btree

  create_table "tours_wheres", id: false, force: :cascade do |t|
    t.integer "tour_id",  null: false
    t.integer "where_id", null: false
  end

  add_index "tours_wheres", ["tour_id", "where_id"], name: "index_tours_wheres_on_tour_id_and_where_id", using: :btree
  add_index "tours_wheres", ["where_id", "tour_id"], name: "index_tours_wheres_on_where_id_and_tour_id", using: :btree

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
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "image"
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
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "place_id"
    t.string   "postal_code"
    t.string   "address"
    t.string   "google_id"
    t.string   "url"
  end

  add_foreign_key "attractions", "languages"
  add_foreign_key "attractions", "quotes"
  add_foreign_key "bank_accounts", "marketplaces"
  add_foreign_key "collaborators", "marketplaces"
  add_foreign_key "comments", "parents"
  add_foreign_key "comments", "users"
  add_foreign_key "confirmeds", "users"
  add_foreign_key "customers", "users"
  add_foreign_key "destinations", "users"
  add_foreign_key "guidebooks", "categories"
  add_foreign_key "guidebooks", "destinations"
  add_foreign_key "guidebooks", "forms"
  add_foreign_key "guidebooks", "organizers"
  add_foreign_key "guidebooks", "users"
  add_foreign_key "marketplaces", "bank_accounts"
  add_foreign_key "marketplaces", "organizers"
  add_foreign_key "members", "users"
  add_foreign_key "orders", "guidebooks"
  add_foreign_key "orders", "tours"
  add_foreign_key "organizers", "marketplaces"
  add_foreign_key "organizers", "members"
  add_foreign_key "organizers", "users"
  add_foreign_key "parents", "comments"
  add_foreign_key "payment_types", "marketplaces"
  add_foreign_key "reviews", "tours"
  add_foreign_key "reviews", "users"
  add_foreign_key "tour_pictures", "tours"
  add_foreign_key "tours", "attractions"
  add_foreign_key "tours", "categories"
  add_foreign_key "tours", "confirmeds"
  add_foreign_key "tours", "languages"
  add_foreign_key "tours", "organizers"
  add_foreign_key "tours", "tags"
  add_foreign_key "tours", "users"
end
