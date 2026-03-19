FactoryBot.define do
  factory :position do
    association :department
    sequence(:title) { |n| "#{Faker::Job.title} #{n}" }
    min_salary { 55_000 }
    max_salary { 70_000 }
    archived_at { nil }
  end
end