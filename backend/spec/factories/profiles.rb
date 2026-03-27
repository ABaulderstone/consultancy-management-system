FactoryBot.define do
  factory :profile do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    title { [ "Mr", "Mrs", "Miss", "Ms" ].sample }
    gender { Profile.genders.keys.sample }
    date_of_birth { Faker::Date.birthday(min_age: 22, max_age: 65) }
    association :user
    sequence(:slug) { |n| "#{first_name.parameterize}-#{last_name.parameterize}-#{n}" }
  end
end
