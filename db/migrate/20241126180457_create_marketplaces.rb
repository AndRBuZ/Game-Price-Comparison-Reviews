class CreateMarketplaces < ActiveRecord::Migration[8.0]
  def change
    create_table :marketplaces do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.string :logo_url

      t.timestamps
    end
  end
end
