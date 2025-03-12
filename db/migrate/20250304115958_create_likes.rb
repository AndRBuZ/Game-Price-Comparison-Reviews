class CreateLikes < ActiveRecord::Migration[8.0]
  def change
    create_table :likes do |t|
      t.integer :reaction, null: false
      t.references :user, null: false, foreign_key: true
      t.references :likeable, polymorphic: true

      t.timestamps
    end
  end
end
