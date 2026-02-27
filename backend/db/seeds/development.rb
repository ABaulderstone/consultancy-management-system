require 'factory_bot_rails'
include FactoryBot::Syntax::Methods

employees = create_list(:user, 20)
employees.each do |employee|
  num_contracts = rand(1..4)
  max_days_needed = num_contracts * 365
  start_date = Faker::Date.between(from: Date.today - (365 * 5), to: Date.today - max_days_needed)

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
