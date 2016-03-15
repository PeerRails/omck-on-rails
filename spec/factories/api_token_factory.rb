FactoryGirl.define do
  factory :api_token, class: ApiToken do
    secret Faker::Internet.password
    expires_at Faker::Date.forward(23)
  end
end
