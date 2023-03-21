FactoryBot.define do
  factory :task do
    title { Faker::Name.name }
    description { Faker::Lorem.sentence }
    due_date { Time.zone.now }
    completed { false }
  end
end
