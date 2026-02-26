User.find_or_create_by!(email: "admin@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
  user.role = :admin
  user.save
  user.create_profile!(
  first_name: "Admin",
  last_name: "User",
  title: "Administrator",
  gender: :prefer_not_to_say,
  date_of_birth: "1985-01-01"
)
end
