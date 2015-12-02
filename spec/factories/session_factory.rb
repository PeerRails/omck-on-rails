FactoryGirl.define do
  factory :session, class: Session do
    guest false
    expires Faker::Date.forward(23)
    session_id Faker::Lorem.characters(16)
    ip Faker::Internet.ip_v4_address
    user
  end
end
