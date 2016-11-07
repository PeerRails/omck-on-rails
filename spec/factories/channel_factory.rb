# == Schema Information
#
# Table name: channels
#
#  id         :integer          not null, primary key
#  channel    :string
#  live       :boolean          default(FALSE)
#  viewers    :integer          default(0), not null
#  game       :string           default("Boku no Pico"), not null
#  streamer   :string           default("McDwarf")
#  title      :string           default("Boku wa Tomodachi ga Sekai")
#  service    :string           default("twitch")
#  created_at :datetime
#  updated_at :datetime
#  official   :boolean          default(FALSE)
#


FactoryGirl.define do
  factory :channel, class: Channel do
    service "hd"
    channel  "hdgames"
    live  false
    viewers 0
    game "Boku no Pico"
    streamer  "McDwarf"
    title "Title"
    official true

    trait :hdchannel do
      service  'hd'
      channel   'hdgames'
      official  true
    end

    trait :twitchchannel do
      service  'twitch'
      channel   'peer_rails'
      official  false
    end
  end
end
