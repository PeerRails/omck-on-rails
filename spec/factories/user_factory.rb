# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  twitter_id          :string
#  screen_name         :string           default("Null"), not null
#  profile_image_url   :string
#  name                :string           default("Anon")
#  gmod                :integer          default(0), not null
#  streamer            :integer          default(0), not null
#  login_last          :date
#  last_ip             :inet
#  access_token        :string
#  secret_token        :string
#  created_at          :datetime
#  updated_at          :datetime
#  remember_created_at :datetime
#  remember_token      :string
#  sign_in_count       :integer          default(0)
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string
#  last_sign_in_ip     :string
#


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
