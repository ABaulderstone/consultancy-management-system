
DAY_RATE = 550

POSITION_DATA = [
  { title: "Junior Frontend Developer", min_salary: 55_000, max_salary: 70_000 },
  { title: "Junior Backend Developer", min_salary: 55_000, max_salary: 70_000 },
  { title: "Junior Full Stack Developer", min_salary: 55_000, max_salary: 70_000 },
  { title: "Junior DevOps Engineer", min_salary: 58_000, max_salary: 72_000 },
  { title: "Junior Site Reliability Engineer", min_salary: 58_000, max_salary: 72_000 },
].freeze

puts "Seeding departments..."

hr = Department.find_or_create_by!(name: "HR") do |d|
  d.billable = false
end

dev = Department.find_or_create_by!(name: "Software Development") do |d|
  d.billable = true
end

puts "Seeding positions..."

hr_position = Position.find_or_create_by!(title: "HR Manager") do |p|
  p.department = hr
  p.min_salary = 70_000
  p.max_salary = 100_000
end

positions = POSITION_DATA.map do |data|
  Position.find_or_create_by!(title: data[:title]) do |p|
    p.department = dev
    p.min_salary = data[:min_salary]
    p.max_salary = data[:max_salary]
  end
end

puts "Seeding clients..."

clients = 10.times.map do
  Client.find_or_create_by!(name: Faker::Company.unique.name)
end

puts "Seeding jobs..."
open_jobs = 60.times.map do
  Job.create!(
    client: clients.sample,
    start_date: Faker::Date.between(from: Date.today - 365, to: Date.today - 30),
    end_date: nil,
    day_rate: DAY_RATE
  )
end

40.times do
  start_date = Faker::Date.between(from: Date.today - (365 * 5), to: Date.today - 730)
  Job.create!(
    client: clients.sample,
    start_date: start_date,
    end_date: start_date + rand(180..730),
    day_rate: DAY_RATE
  )
end

historical_jobs = Job.where.not(end_date: nil).to_a.shuffle
historical_job_queue = historical_jobs.dup



puts "Seeding admin..."

admin = User.find_or_create_by!(email: "admin@example.com") do |user|
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
puts "Admin: admin@example.com / password123"

Contracts::CreateContract.call(params: {
  user_id: admin.id,
  position_id: hr_position.id,
  contract_type: :full_time,
  fte: 1.0,
  rate: 85_000,
  start_date: Date.today - (365 * 5),
  end_date: nil
})



puts "Seeding employees..."

employee_statuses = (
  [:active_job] * 60 +
  [:bench] * 20 +
  [:departed] * 20
).shuffle

job_queue = open_jobs.shuffle

100.times do
  status = employee_statuses.pop
  position = positions.sample

  result = Users::CreateUser.call(params: {
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 45),
    title: Faker::Name.prefix
  })

  user = result[:user]
  puts "Created: #{user.email} / #{result[:password]}"

  contract_start = Faker::Date.between(
    from: Date.today - (365 * 5),
    to: Date.today - 365
  )

  contract_end = status == :departed ? contract_start + rand(365..730) : nil

  Contracts::CreateContract.call(params: {
    user_id: user.id,
    position_id: position.id,
    contract_type: :full_time,
    fte: 1.0,
    rate: rand(position.min_salary.to_i..position.max_salary.to_i),
    start_date: contract_start,
    end_date: contract_end
  })

  if status == :active_job && job_queue.any?
    job = job_queue.pop
    Assignment.create!(
      job: job,
      user: user,
      start_date: [contract_start, job.start_date].max,
      end_date: nil
    )
  elsif status == :departed && historical_job_queue.any?
    job = historical_job_queue.pop
    assignment_start = [contract_start, job.start_date].max
    assignment_end = [contract_end, job.end_date].min
    Assignment.create!(
      job: job,
      user: user,
      start_date: assignment_start,
      end_date: assignment_end
    )
  end
end

puts "Done! Seeded #{User.count} users, #{Job.count} jobs, #{Assignment.count} assignments."
