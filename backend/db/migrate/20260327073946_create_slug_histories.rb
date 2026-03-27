class CreateSlugHistories < ActiveRecord::Migration[8.1]
  def change
    create_table :slug_histories do |t|
      t.string :slug, null: false
      t.references :user, null: false, foreign_key: true
      t.datetime :expires_at, null: false

      t.timestamps
      t.index [:slug, :expires_at]
    end
  end
end
