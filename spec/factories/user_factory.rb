FactoryGirl.define do
  factory :user, class: User do
    twitter_id Faker::Number.number(10)
    screen_name Faker::Internet.user_name
    name  Faker::Name.name
    profile_image_url Faker::Avatar.image(Faker::Internet.user_name, "50x50", "jpg")

    trait :streamer do
      twitter_id "11112"
      screen_name "test_streamer"
      name  "TestStreamer"
      streamer  1
    end

    trait :mod do
      twitter_id "11113"
      screen_name "test_gmod"
      name  "TestGmod"
      gmod 1
    end

    trait :admin do
      twitter_id "11114"
      screen_name "test_admin"
      name  "TestAdmin"
      gmod 1
      streamer 1
    end
    trait :guest do
      gmod 0
      streamer 0
    end
  end
end
