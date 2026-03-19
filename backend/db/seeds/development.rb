
JUNIOR_DAY_RATE = 550
SENIOR_DAY_RATE = 650

JOB_TITLES = [
  "Frontend Developer",
  "Backend Developer",
  "Full Stack Developer",
  "DevOps Engineer",
  "Site Reliability Engineer",
  "Business Analyst",
  "QA Engineer",
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

junior_position = Position.find_or_create_by!(title: "Software Consultant") do |p|
  p.department = dev
  p.min_salary = 55_000
  p.max_salary = 70_000
end

senior_position = Position.find_or_create_by!(title: "Senior Software Consultant") do |p|
  p.department = dev
  p.min_salary = 75_000
  p.max_salary = 95_000
end



puts "Seeding clients..."

clients = 10.times.map do
  Client.find_or_create_by!(name: Faker::Company.unique.name)
end



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
  [:departed] * 10 +
  [:promoted] * 10
).shuffle



100.times do
  status = employee_statuses.pop

  result = Users::CreateUser.call(params: {
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 45),
    title: Faker::Name.prefix
  })

  user = result[:user]
  puts "Created: #{user.email} / #{result[:password]}"


  case status
  when :active_job
    contract_start = Faker::Date.between(
      from: Date.today - (365 * 5),
      to: Date.today - 365
    )

    Contracts::CreateContract.call(params: {
      user_id: user.id,
      position_id: junior_position.id,
      contract_type: :full_time,
      fte: 1.0,
      rate: rand(junior_position.min_salary.to_i..junior_position.max_salary.to_i),
      start_date: contract_start,
      end_date: nil
    })

    job_start = contract_start + rand(1..14)
    job = Job.create!(
      client: clients.sample,
      title: JOB_TITLES.sample,
      start_date: job_start,
      end_date: nil,
      day_rate: JUNIOR_DAY_RATE
    )

    Assignment.create!(
      job: job,
      user: user,
      start_date: job_start,
      end_date: nil
    )

  when :bench
  contract_start = Faker::Date.between(
    from: Date.today - 30,
    to: Date.today - 1
  )

    Contracts::CreateContract.call(params: {
      user_id: user.id,
      position_id: junior_position.id,
      contract_type: :full_time,
      fte: 1.0,
      rate: rand(junior_position.min_salary.to_i..junior_position.max_salary.to_i),
      start_date: contract_start,
      end_date: nil
    })

  when :departed
    contract_start = Faker::Date.between(
      from: Date.today - (365 * 5),
      to: Date.today - (365 * 2)
    )
    contract_end = contract_start + rand(365..730)

    Contracts::CreateContract.call(params: {
      user_id: user.id,
      position_id: junior_position.id,
      contract_type: :full_time,
      fte: 1.0,
      rate: rand(junior_position.min_salary.to_i..junior_position.max_salary.to_i),
      start_date: contract_start,
      end_date: contract_end
    })

    job_start = contract_start + rand(1..14)
    job_end = contract_end - rand(1..14)

    if job_end > job_start
      job = Job.create!(
        client: clients.sample,
        title: JOB_TITLES.sample,
        start_date: job_start,
        end_date: job_end,
        day_rate: JUNIOR_DAY_RATE
      )

      Assignment.create!(
        job: job,
        user: user,
        start_date: job_start,
        end_date: job_end
      )
    end

  when :promoted
    junior_contract_start = Faker::Date.between(
      from: Date.today - (365 * 5),
      to: Date.today - (365 * 2)
    )
    junior_contract_end = junior_contract_start + rand(365..730)

    Contracts::CreateContract.call(params: {
      user_id: user.id,
      position_id: junior_position.id,
      contract_type: :full_time,
      fte: 1.0,
      rate: rand(junior_position.min_salary.to_i..junior_position.max_salary.to_i),
      start_date: junior_contract_start,
      end_date: junior_contract_end
    })

    # junior job starts shortly after contract, ends before contract ends
    junior_job_start = junior_contract_start + rand(1..14)
    junior_job_end = junior_contract_end - rand(1..14)

    if junior_job_end > junior_job_start
      junior_job = Job.create!(
        client: clients.sample,
        title: JOB_TITLES.sample,
        start_date: junior_job_start,
        end_date: junior_job_end,
        day_rate: JUNIOR_DAY_RATE
      )

      Assignment.create!(
        job: junior_job,
        user: user,
        start_date: junior_job_start,
        end_date: junior_job_end
      )
    end

    # senior contract starts 0-14 days after junior contract ends (bench period)
    senior_contract_start = junior_contract_end + rand(0..14)

    Contracts::CreateContract.call(params: {
      user_id: user.id,
      position_id: senior_position.id,
      contract_type: :full_time,
      fte: 1.0,
      rate: rand(senior_position.min_salary.to_i..senior_position.max_salary.to_i),
      start_date: senior_contract_start,
      end_date: nil
    })

    senior_job_start = senior_contract_start

    senior_job = Job.create!(
      client: clients.sample,
      title: JOB_TITLES.sample,
      start_date: senior_job_start,
      end_date: nil,
      day_rate: SENIOR_DAY_RATE
    )

    Assignment.create!(
      job: senior_job,
      user: user,
      start_date: senior_job_start,
      end_date: nil
    )
  end
end

puts "Done! Seeded #{User.count} users, #{Job.count} jobs, #{Assignment.count} assignments."
