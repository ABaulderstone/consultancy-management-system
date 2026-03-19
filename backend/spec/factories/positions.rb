FactoryBot.define do
  factory :position do
    association :department
    title { Faker::Job.title }
    min_salary { 55_000 }
    max_salary { 70_000 }
    archived_at { nil }
  end
end