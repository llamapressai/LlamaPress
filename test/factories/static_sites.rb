FactoryBot.define do
  factory :static_site do
    association :team
    name { "MyString" }
    slug { "MyString" }
  end
end
