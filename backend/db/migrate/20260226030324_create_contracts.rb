class CreateContracts < ActiveRecord::Migration[8.1]
  def change
    create_table :contracts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.decimal :salary, precision: 10, scale: 2, null: false
      t.date :start_date, null: false
      t.date :end_date

      t.timestamps
    end
  end
end
