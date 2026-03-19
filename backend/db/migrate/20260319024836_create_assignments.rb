class CreateAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :assignments do |t|
      t.references :job, null: false, foreign_key: { on_delete: :restrict }
      t.references :user, null: false, foreign_key: { on_delete: :restrict }
      t.date :start_date
      t.date :end_date

      t.timestamps
    end

    add_index :assignments, :user_id,
      unique: true,
      where: "end_date IS NULL",
      name: "index_one_active_assignment_per_user"

    add_index :assignments, :job_id,
      unique: true,
      where: "end_date IS NULL",
      name: "index_one_active_assignment_per_job"
  end
end
