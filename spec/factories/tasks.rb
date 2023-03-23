FactoryBot.define do
  factory :task do
    title { Faker::Name.name }
    description { Faker::Lorem.sentence }
    due_date { Faker::Date.between(from: 10.days.ago, to: Date.today) }
    completed { Faker::Boolean }
  end
end
