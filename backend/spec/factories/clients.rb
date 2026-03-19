FactoryBot.define do
  factory :client do
    name { Faker::Company.unique.name }
  end
end