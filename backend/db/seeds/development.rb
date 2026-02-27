require 'factory_bot_rails'
include FactoryBot::Syntax::Methods

employees = 20.times.map do
  result = Users::CreateUser.call(params: {
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 65)
  })

  puts "Created user: #{result[:user].email} / #{result[:password]}"

  result[:user]
end

employees.each do |employee|
  num_contracts = rand(1..4)
  max_days_needed = num_contracts * 365
  start_date = Faker::Date.between(from: Date.today - (365 * 4), to: Date.today - max_days_needed)

  num_contracts.times do |i|
    last_contract = i == num_contracts - 1
    end_date = last_contract ? nil : start_date + rand(180..365)

    FactoryBot.create(
      :contract,
      user: employee,
      start_date: start_date,
      end_date: end_date
    )

    start_date = end_date + 1 if end_date
  end
end
