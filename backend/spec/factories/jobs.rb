FactoryBot.define do
  factory :job do
    association :client
    title {Faker::Job.title}
    start_date { Faker::Date.backward(days: 365) }
    end_date { nil }
    day_rate { 550 }
  end
end