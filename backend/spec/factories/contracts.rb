FactoryBot.define do
  factory :contract do
    association :user
    association :position
    contract_type { :full_time }
    rate { rand(55_000..70_000) }
    fte { 1.0 }
    start_date { Faker::Date.backward(days: 365 * 3) }
    end_date { Faker::Date.forward(days: 365 * 2) }

    trait :current do
      end_date { nil }
    end

    trait :part_time do
      contract_type { :part_time }
      fte { 0.6 }
    end

    trait :contractor do
      contract_type { :contractor }
      fte { nil }
      rate { rand(400..800) }
    end
  end
end
