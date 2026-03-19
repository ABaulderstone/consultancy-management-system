FactoryBot.define do
  factory :job do
    association :client
    start_date { Faker::Date.backward(days: 365) }
    end_date { nil }
    day_rate { 550 }
  end
end