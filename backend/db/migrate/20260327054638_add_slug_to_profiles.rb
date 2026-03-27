class AddSlugToProfiles < ActiveRecord::Migration[8.1]
  def up
    add_column :profiles, :slug, :string
    execute <<-SQL 
      UPDATE profiles
      SET slug = LOWER(first_name) || '-' || LOWER(last_name) || '-' || user_id
    SQL
  end

  def down
    remove_column :profiles, :slug
  end
end
