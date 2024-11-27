class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.string :name, null: false
      t.text :description
      t.string :developer
      t.string :publisher
      t.date :released_at

      t.timestamps
    end
  end
end
