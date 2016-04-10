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

ActiveRecord::Schema.define(version: 20160410165715) do

  create_table "expa_applications", force: :cascade do |t|
    t.integer  "xp_id"
    t.string   "xp_url"
    t.integer  "xp_status"
    t.integer  "xp_current_status"
    t.text     "xp_permissions"
    t.datetime "xp_created_at"
    t.datetime "xp_updated_at"
    t.integer  "xp_opportunity_id"
    t.boolean  "xp_interviewed",            default: false
    t.integer  "xp_person_id"
    t.datetime "xp_an_signed_at"
    t.datetime "xp_experience_start_date"
    t.datetime "xp_experience_end_date"
    t.datetime "xp_matched_or_rejected_at"
    t.datetime "xp_date_matched"
    t.datetime "xp_date_realized"
    t.datetime "xp_date_completed"
    t.datetime "xp_date_ldm_completed"
    t.boolean  "xp_paid",                   default: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "expa_current_positions", force: :cascade do |t|
    t.integer  "xp_id"
    t.string   "xp_position_name"
    t.string   "xp_position_short_name"
    t.string   "xp_url"
    t.datetime "xp_start_date"
    t.datetime "xp_end_date"
    t.text     "xp_job_description"
    t.integer  "xp_team_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "expa_offices", force: :cascade do |t|
    t.integer  "xp_id"
    t.string   "xp_name"
    t.string   "xp_full_name"
    t.string   "xp_url"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "expa_opportunities", force: :cascade do |t|
    t.integer  "xp_id"
    t.string   "xp_title"
    t.string   "xp_url"
    t.integer  "xp_status"
    t.string   "xp_location"
    t.text     "xp_programmes"
    t.integer  "xp_office_id"
    t.integer  "xp_application_count"
    t.date     "xp_earliest_start_date"
    t.date     "xp_latest_end_date"
    t.date     "xp_applications_close_date"
    t.string   "xp_profile_photo_url"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "expa_people", force: :cascade do |t|
    t.integer  "xp_id"
    t.string   "xp_email"
    t.string   "xp_url"
    t.date     "xp_birthday_date"
    t.string   "xp_full_name"
    t.string   "xp_last_name"
    t.string   "xp_profile_photo_url"
    t.integer  "xp_home_lc_id"
    t.integer  "xp_home_mc_id"
    t.integer  "xp_status"
    t.boolean  "xp_interviewed",            default: false
    t.string   "xp_phone"
    t.string   "xp_location"
    t.datetime "xp_created_at"
    t.datetime "xp_updated_at"
    t.string   "xp_middles_names"
    t.string   "xp_introduction"
    t.string   "xp_aiesec_email"
    t.boolean  "xp_payment",                default: false
    t.integer  "xp_views"
    t.integer  "xp_favourites_count"
    t.datetime "xp_contacted_at"
    t.string   "xp_contacted_by"
    t.integer  "xp_gender"
    t.text     "xp_address_info"
    t.string   "xp_contact_info"
    t.integer  "xp_current_office_id"
    t.string   "xp_cv_info"
    t.string   "xp_profile_photos_urls"
    t.string   "xp_cover_photo_urls"
    t.string   "xp_profile"
    t.string   "xp_academic_experience"
    t.string   "xp_missing_profile_fields"
    t.integer  "xp_nps_score"
    t.string   "xp_permissions"
    t.integer  "xp_current_position_id"
    t.integer  "entity_exchange_lc_id"
    t.integer  "interested_program"
    t.integer  "interested_sub_product"
    t.integer  "how_got_to_know_aiesec"
    t.text     "customized_fields"
    t.text     "control_podio"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "expa_teams", force: :cascade do |t|
    t.integer  "xp_id"
    t.string   "xp_title"
    t.integer  "xp_team_type"
    t.string   "xp_url"
    t.integer  "xp_office_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "file_tags", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "archive_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

# Could not dump table "files" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "host_people", force: :cascade do |t|
    t.string   "full_name"
    t.integer  "phone",                    limit: 8
    t.string   "email"
    t.string   "address"
    t.integer  "cep"
    t.string   "state"
    t.string   "city"
    t.integer  "house_type"
    t.integer  "trainees_vacancy"
    t.integer  "weeks_vacancy"
    t.integer  "newest_lc"
    t.integer  "how_got_to_know_aiesec"
    t.integer  "tmp_responsable"
    t.datetime "date_approach"
    t.datetime "date_alignment_meeting"
    t.integer  "tmp_who_realized_meeting"
    t.boolean  "is_favourite"
    t.boolean  "is_problematic"
    t.boolean  "is_non_grata_person"
    t.text     "is_non_grata_description"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "host_problems", force: :cascade do |t|
    t.datetime "reported_date"
    t.text     "problem_description"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trainee_people", force: :cascade do |t|
    t.string   "full_name"
    t.datetime "arrival_date"
    t.datetime "departure_date"
    t.integer  "local_committee"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "trainee_to_hosts", force: :cascade do |t|
    t.datetime "entry_date"
    t.datetime "exit_date"
    t.integer  "host_evaluation"
    t.integer  "trainee_evaluation"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

end
