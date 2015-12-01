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