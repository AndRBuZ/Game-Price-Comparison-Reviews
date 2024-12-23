class UpdateGameMarketplacesTableAndAddColumn < ActiveRecord::Migration[8.0]
  def change
    change_column :game_marketplaces, :price, :string, null: false
    add_column :game_marketplaces, :steam_id, :integer
  end
end
