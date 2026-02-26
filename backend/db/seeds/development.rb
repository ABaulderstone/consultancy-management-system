require 'factory_bot_rails'
include FactoryBot::Syntax::Methods

employees = create_list(:user, 20)
employees.each do |employee|
  num_contracts = rand(1..3)
  start_date = Faker::Date.backward(days: 365 * 3)

  num_contracts.times do |i|
    end_date = (i == num_contracts - 1) ? nil : start_date + rand(180..365)
    FactoryBot.create(
      :contract,
      user: employee,
      start_date: start_date,
      end_date: end_date
    )

    start_date = end_date ? end_date + 1 : start_date
  end
end
