FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    due_date { "2023-03-19 14:21:38" }
    completed { false }
  end
end
