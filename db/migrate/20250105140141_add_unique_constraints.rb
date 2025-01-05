class AddUniqueConstraints < ActiveRecord::Migration[8.0]
  def change
    add_index :games, :name, unique: true
    add_index :marketplaces, [ :name, :url ], unique: true
    add_index :game_marketplaces, [ :steam_id, :xbox_id ], unique: true
    add_index :genres, :name, unique: true
  end
end
