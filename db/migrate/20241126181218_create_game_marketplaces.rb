class CreateGameMarketplaces < ActiveRecord::Migration[8.0]
  def change
    create_table :game_marketplaces do |t|
      t.integer :price, null: false
      t.string :rating
      t.references :game, null: false, foreign_key: true
      t.references :marketplace, null: false, foreign_key: true

      t.timestamps
    end
  end
end
