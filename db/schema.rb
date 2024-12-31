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

ActiveRecord::Schema[8.0].define(version: 2024_12_29_173744) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "game_marketplaces", force: :cascade do |t|
    t.string "price", null: false
    t.string "rating"
    t.bigint "game_id", null: false
    t.bigint "marketplace_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "steam_id"
    t.string "xbox_id"
    t.index ["game_id"], name: "index_game_marketplaces_on_game_id"
    t.index ["marketplace_id"], name: "index_game_marketplaces_on_marketplace_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "developer"
    t.string "publisher"
    t.date "released_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games_genres", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "genre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_games_genres_on_game_id"
    t.index ["genre_id"], name: "index_games_genres_on_genre_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "marketplaces", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.string "logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "game_marketplaces", "games"
  add_foreign_key "game_marketplaces", "marketplaces"
  add_foreign_key "games_genres", "games"
  add_foreign_key "games_genres", "genres"
end
