FactoryGirl.define do
  factory :tweet, class: Tweet do
    comment Faker::Lorem.characters(70)
  end
end
