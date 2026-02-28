FactoryBot.define do
  factory :contract do
    association :user
    title { [ "Software Engineer", "Product Manager", "QA Analyst", "Designer" ].sample }
    salary { rand(60_000..150_000) }
    start_date { Faker::Date.backward(days: 365 * 3) }
    end_date { Faker::Date.forward(days: 365 * 2) }


    # Optional trait for current contract
    trait :current do
      end_date { nil }
    end
  end
end
