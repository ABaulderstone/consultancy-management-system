class CreateJobs < ActiveRecord::Migration[8.1]
  def change
    create_table :jobs do |t|
      t.references :client, null: false, foreign_key: { on_delete: :restrict }
      t.date :start_date, null: false
      t.date :end_date
      t.decimal :day_rate, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
