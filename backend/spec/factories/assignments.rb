FactoryBot.define do
  factory :assignment do
    association :job
    association :user
    start_date { Faker::Date.backward(days: 180) }
    end_date { nil }
  end
end