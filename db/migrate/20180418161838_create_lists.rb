class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.string :name, null: false
      t.references :user, foreign_key: true, null: false
      t.string :access_type, null: false
      t.string :status, null: false

      t.timestamps
    end
  end
end
