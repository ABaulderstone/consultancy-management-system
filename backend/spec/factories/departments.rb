FactoryBot.define do
  factory :department do
    name { Faker::Company.industry }
    billable { true }

    trait :non_billable do
      billable { false }
    end
  end
end