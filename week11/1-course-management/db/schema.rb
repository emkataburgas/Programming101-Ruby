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

ActiveRecord::Schema.define(version: 20160226221917) do

  create_table "lectures", force: true do |t|
    t.string "name",      null: false
    t.text   "text_body", null: false
  end

  create_table "solutions", force: true do |t|
    t.text    "text_block", null: false
    t.integer "task_id",    null: false
  end

  add_index "solutions", ["task_id"], name: "index_solutions_on_task_id"

  create_table "tasks", force: true do |t|
    t.string  "name",        null: false
    t.text    "description", null: false
    t.integer "lecture_id",  null: false
  end

  add_index "tasks", ["lecture_id"], name: "index_tasks_on_lecture_id"

end
