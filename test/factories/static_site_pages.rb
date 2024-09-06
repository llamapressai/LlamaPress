FactoryBot.define do
  factory :static_site_page do
    association :static_site
    content { "MyString" }
    slug { "MyString" }
    prompt { "MyString" }
  end
end
