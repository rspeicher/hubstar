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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120229165536) do

  create_table "repositories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "watchers"
    t.integer  "forks"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "language"
  end

  add_index "repositories", ["name"], :name => "index_repositories_on_name", :unique => true

  create_table "repositories_users", :force => true do |t|
    t.integer "user_id"
    t.integer "repository_id"
  end

  add_index "repositories_users", ["repository_id"], :name => "index_repositories_users_on_repository_id"
  add_index "repositories_users", ["user_id"], :name => "index_repositories_users_on_user_id"

  create_table "users", :force => true do |t|
    t.string "username"
    t.string "github_access_token"
    t.text   "github_data"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
