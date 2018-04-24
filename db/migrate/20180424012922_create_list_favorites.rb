class CreateListFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :list_favorites do |t|
      t.references :list, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false

      t.index [:user_id, :list_id], unique: true

      t.timestamps
    end
  end
end
