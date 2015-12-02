FactoryGirl.define do
  factory :key, class: Key do
    key Faker::Internet.password
    game  Faker::Company.name
    movie Faker::Book.title
    expires Faker::Date.forward(23)
    streamer Faker::Name.name
    guest false
  end
end
