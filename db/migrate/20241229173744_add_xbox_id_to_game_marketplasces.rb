class AddXboxIdToGameMarketplasces < ActiveRecord::Migration[8.0]
  def change
    add_column :game_marketplaces, :xbox_id, :string
  end
end
