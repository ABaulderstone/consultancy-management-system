class CreateDepartments < ActiveRecord::Migration[8.1]
  def change
    create_table :departments do |t|
      t.string :name
      t.boolean :billable

      t.timestamps
    end
  end
end
