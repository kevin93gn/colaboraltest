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

ActiveRecord::Schema.define(version: 20190625040119) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.date     "date"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bootsy_image_galleries", force: :cascade do |t|
    t.string   "bootsy_resource_type"
    t.integer  "bootsy_resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: :cascade do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coachee_goals", force: :cascade do |t|
    t.boolean  "completed"
    t.integer  "user_id"
    t.integer  "goal_id"
    t.integer  "coaching_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "coachees", force: :cascade do |t|
    t.integer  "coaching_id",                 null: false
    t.integer  "user_id",                     null: false
    t.boolean  "completed",   default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "pdi"
  end

  create_table "coaching_activities", force: :cascade do |t|
    t.string   "name"
    t.text     "text"
    t.datetime "date"
    t.integer  "coaching_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "coaching_graphs", force: :cascade do |t|
    t.integer  "coaching_id"
    t.integer  "user_id"
    t.float    "point_1"
    t.float    "point_2"
    t.float    "point_3"
    t.float    "point_4"
    t.float    "point_5"
    t.float    "point_6"
    t.float    "point_7"
    t.float    "point_8"
    t.float    "point_9"
    t.float    "point_10"
    t.float    "point_11"
    t.integer  "version"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "coaching_news", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.integer  "user_id"
    t.integer  "coaching_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "image"
  end

  create_table "coaching_session", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_coaching_session_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_coaching_session_on_updated_at", using: :btree
  end

  create_table "coaching_sessions", force: :cascade do |t|
    t.string   "name"
    t.date     "date"
    t.text     "description"
    t.string   "file"
    t.integer  "coaching_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "coachings", force: :cascade do |t|
    t.string   "name",                        null: false
    t.text     "description"
    t.integer  "user_id",                     null: false
    t.integer  "creator_id",                  null: false
    t.boolean  "publish",     default: false, null: false
    t.date     "start"
    t.date     "end"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "communication_mails", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "enterprise"
    t.string   "job"
    t.string   "linkedin_url"
    t.string   "consultant"
    t.string   "category"
    t.integer  "status"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
    t.text     "reject_reason"
    t.index ["user_id"], name: "index_contacts_on_user_id", using: :btree
  end

  create_table "course_evaluation_answers", force: :cascade do |t|
    t.string   "answer"
    t.integer  "course_user_evaluation_id"
    t.integer  "evaluation_questionnaire_id"
    t.integer  "course_evaluation_question_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "course_evaluation_question_alternatives", force: :cascade do |t|
    t.string  "text"
    t.integer "course_evaluation_question_id"
    t.string  "position"
  end

  create_table "course_evaluation_questionnaires", force: :cascade do |t|
    t.boolean  "visible"
    t.integer  "course_id"
    t.integer  "evaluation_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "course_evaluation_questions", force: :cascade do |t|
    t.string   "text"
    t.integer  "position"
    t.string   "correct_answer"
    t.integer  "course_evaluation_questionnaire_id"
    t.integer  "course_evaluation_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "course_evaluations", force: :cascade do |t|
    t.integer  "course_id"
    t.string   "name"
    t.text     "description"
    t.integer  "module_item_id"
    t.text     "file"
    t.string   "file_name"
    t.text     "file_description"
    t.text     "kind"
    t.boolean  "user_upload_expected"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "evaluation_file"
    t.boolean  "visible"
    t.boolean  "grades_visible",       default: false
  end

  create_table "course_modules", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "position",   null: false
    t.integer  "course_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_user_evaluations", force: :cascade do |t|
    t.integer  "grade"
    t.text     "text"
    t.integer  "course_id"
    t.integer  "user_id"
    t.integer  "course_evaluation_questionnaire_id"
    t.integer  "module_item_id"
    t.boolean  "sent"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name",                                            null: false
    t.text     "description"
    t.integer  "teacher_id",                                      null: false
    t.integer  "creator_id",                                      null: false
    t.integer  "hours"
    t.string   "category",                  default: "eLearning", null: false
    t.boolean  "all_subscribed",                                  null: false
    t.boolean  "publish",                   default: false,       null: false
    t.string   "forum"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.date     "start"
    t.date     "end"
    t.boolean  "external_users_subscribed", default: false
  end

  create_table "forums", force: :cascade do |t|
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goals", force: :cascade do |t|
    t.string   "name"
    t.string   "subfactor"
    t.integer  "percentage"
    t.date     "end_date"
    t.text     "description"
    t.integer  "coaching_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "is_global"
    t.integer  "user_id"
  end

  create_table "grades", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "course_evaluation_id"
    t.integer  "user_id"
    t.float    "grade"
    t.string   "user_file"
    t.datetime "user_file_date_uploaded"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "job_offers", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "coaching_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "status"
    t.string   "description"
    t.string   "source"
    t.text     "reject_reason"
  end

  create_table "module_items", force: :cascade do |t|
    t.string   "title",             null: false
    t.text     "text"
    t.integer  "course_id",         null: false
    t.integer  "course_module_id",  null: false
    t.string   "media_url",         null: false
    t.string   "media_type",        null: false
    t.integer  "time_in_mins"
    t.string   "disqus_identifier", null: false
    t.integer  "position",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data"
    t.string   "data_title"
    t.text     "data_description"
    t.string   "presentation"
  end

  create_table "module_items_users", force: :cascade do |t|
    t.boolean  "status",                    default: false, null: false
    t.integer  "user_id",                                   null: false
    t.integer  "module_item_id",                            null: false
    t.integer  "course_id",                                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "visits"
    t.boolean  "sent",                      default: false
    t.string   "evaluation_file"
    t.integer  "course_user_evaluation_id"
  end

  create_table "question_alternatives", force: :cascade do |t|
    t.string   "text"
    t.integer  "question_id"
    t.string   "position"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "question_answers", force: :cascade do |t|
    t.string   "answer"
    t.integer  "user_evaluation_id"
    t.integer  "questionnaire_id"
    t.integer  "question_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "questionnaires", force: :cascade do |t|
    t.boolean  "completed"
    t.boolean  "visible"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string   "text"
    t.integer  "position"
    t.string   "correct_answer"
    t.integer  "questionnaire_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "course_id",                  null: false
    t.integer  "user_id",                    null: false
    t.boolean  "completed",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_evaluations", force: :cascade do |t|
    t.integer  "grade"
    t.text     "text"
    t.integer  "course_id"
    t.integer  "user_id"
    t.integer  "questionnaire_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.boolean  "sent"
  end

  create_table "user_roles", force: :cascade do |t|
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             default: "",     null: false
    t.string   "last_name",              default: "",     null: false
    t.string   "rut",                    default: "",     null: false
    t.string   "role",                   default: "user", null: false
    t.string   "avatar_url"
    t.string   "client"
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "institution"
    t.string   "profession"
    t.string   "phone"
    t.string   "mobile"
    t.string   "company_name"
    t.string   "company_rut"
    t.string   "company_region"
    t.string   "company_phone"
    t.string   "company_email"
    t.string   "company_address"
    t.string   "company_activity"
    t.string   "company_type"
    t.boolean  "external_user",          default: false
    t.string   "branch"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
