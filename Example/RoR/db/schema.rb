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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110112032747) do

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "planned_start_at"
    t.integer  "published_by"
    t.boolean  "is_prototype",                           :default => false
    t.string   "state",                                  :default => "unallocated"
    t.text     "custom_fields"
    t.integer  "account_id"
    t.datetime "deleted_at"
    t.string   "batch_id"
    t.integer  "planned_duration"
    t.datetime "actual_start_at"
    t.datetime "actual_end_at"
    t.integer  "proof_of_deliveries_count",              :default => 0
    t.datetime "published_at"
    t.string   "progress_state",                         :default => "not_started"
    t.string   "third_party_id",                         :default => ""
    t.string   "template_name"
    t.integer  "customer_id"
    t.string   "zone",                      :limit => 2
    t.datetime "requested_at"
    t.datetime "alarm_at"
    t.integer  "worker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "read_count"
    t.float    "lat"
    t.decimal  "lng"
    t.datetime "published_at"
    t.time     "last_read"
    t.date     "actioned_at"
    t.boolean  "published"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "worker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "milestones", :force => true do |t|
    t.string   "title"
    t.datetime "completed_at"
    t.integer  "sequence_order"
    t.datetime "deleted_at"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workers", :force => true do |t|
    t.string   "name"
    t.integer  "account_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "head_telemetry_id"
    t.decimal  "lat"
    t.decimal  "lng"
    t.datetime "effective_at"
    t.decimal  "speed"
    t.decimal  "heading"
    t.string   "third_party_id",    :default => ""
  end

end
