require 'factory_bot_rails'
include FactoryBot::Syntax::Methods

employees = 20.times.map do
  result = Users::CreateUser.call(params: {
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 65),
    title: Faker::Name.prefix
  })

  puts "Created user: #{result[:user].email} / #{result[:password]}"

  result[:user]
end

employees.each do |employee|
  num_contracts = rand(1..4)
  max_days_needed = num_contracts * 365
  start_date = Faker::Date.between(from: Date.today - (365 * 5), to: Date.today - max_days_needed)
  base_title = Faker::Job.title
  levels = ["Junior #{base_title}", "#{base_title}", "Senior #{base_title}", "Lead #{base_title}"].first(num_contracts)
  salary = rand(50_000..65_000)

  levels.each_with_index do |title, i|
    last_contract = i == num_contracts - 1
    end_date = last_contract ? nil : start_date + rand(180..365)
    Contracts::CreateContract.call(params: {
      user_id: employee.id,
      start_date: start_date,
      end_date: end_date,
      title: title,
      salary: salary
    })
    start_date = end_date + rand(-28..28) if end_date
    salary += rand(2_000..10_000)
  end
end

