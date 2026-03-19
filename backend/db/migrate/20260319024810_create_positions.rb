class CreatePositions < ActiveRecord::Migration[8.1]
  def change
    create_table :positions do |t|
      t.string :title
      t.references :department, null: false, foreign_key: { on_delete: :restrict }
      t.decimal :min_salary, precision: 10, scale: 2
      t.decimal :max_salary, precision: 10, scale: 2
      t.datetime :archived_at

      t.timestamps
    end
  end
end
