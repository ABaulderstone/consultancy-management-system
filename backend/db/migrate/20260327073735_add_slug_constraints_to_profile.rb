class AddSlugConstraintsToProfile < ActiveRecord::Migration[8.1]
  def change
    change_column_null :profiles, :slug, false
    add_index :profiles, :slug, unique: true
  end
end
