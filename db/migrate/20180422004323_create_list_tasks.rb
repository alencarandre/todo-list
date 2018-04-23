class CreateListTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :list_tasks do |t|
      t.references :list, foreign_key: true
      t.string :name
      t.references :list_task, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
