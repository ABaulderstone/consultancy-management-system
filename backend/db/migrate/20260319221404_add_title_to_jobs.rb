class AddTitleToJobs < ActiveRecord::Migration[8.1]
  def change
    add_column :jobs, :title, :string, null: false
  end
end
