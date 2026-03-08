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

ActiveRecord::Schema[8.1].define(version: 2026_03_08_135102) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "packages", force: :cascade do |t|
    t.string "authors", default: [], array: true
    t.datetime "created_at", null: false
    t.string "description"
    t.string "homepage"
    t.string "license"
    t.string "name"
    t.string "repository"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_packages_on_name", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "commit_sha"
    t.datetime "created_at", null: false
    t.string "git_url"
    t.string "manifest_hash"
    t.bigint "package_id", null: false
    t.string "platforms", default: [], array: true
    t.jsonb "system_deps"
    t.datetime "updated_at", null: false
    t.string "version"
    t.boolean "yanked", default: false, null: false
    t.index ["package_id"], name: "index_versions_on_package_id"
  end

  add_foreign_key "versions", "packages"
end
