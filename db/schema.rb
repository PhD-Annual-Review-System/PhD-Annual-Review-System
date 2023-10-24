# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_10_19_060555) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email_id"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  create_table "assessments", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "faculty_id"
    t.text "public_comment"
    t.string "rating"
    t.boolean "eligible_for_reward", default: false
    t.text "private_comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["faculty_id"], name: "index_assessments_on_faculty_id"
    t.index ["student_id"], name: "index_assessments_on_student_id"
  end

  create_table "committees", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "faculty_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "Member"
    t.index ["faculty_id"], name: "index_committees_on_faculty_id"
    t.index ["student_id"], name: "index_committees_on_student_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "file_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "faculties", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email_id"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  create_table "student_documents", force: :cascade do |t|
    t.binary "resume_file"
    t.string "resume_link"
    t.string "email_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phd_start_date"
    t.text "milestones_passed"
    t.string "improvement_plan_present"
    t.text "improvement_plan_summary"
    t.float "gpa"
    t.text "support_in_last_sem"
    t.integer "number_of_paper_submissions"
    t.integer "number_of_papers_published"
    t.string "report_link"
    t.binary "report_file"
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "UIN"
    t.string "email_id"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.index ["email_id"], name: "index_students_on_email_id", unique: true
  end

  add_foreign_key "assessments", "faculties"
  add_foreign_key "assessments", "students"
  add_foreign_key "committees", "faculties"
  add_foreign_key "committees", "students"
  add_foreign_key "student_documents", "students", column: "email_id", primary_key: "email_id"
end
