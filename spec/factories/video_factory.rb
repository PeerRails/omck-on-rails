FactoryGirl.define do
  factory :video, class: Video do
    game  Faker::Book.title
    description Faker::Lorem.characters(42)
    token Faker::Internet.password
    path  Faker::Internet.url
    deleted false
  end
end
