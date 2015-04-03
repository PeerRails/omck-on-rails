# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Channel.create([{
    channel: 'mc_mc_mc_omck',
    live: false,
    viewers: 0,
    service: 'livestream',
    game: 'Boku Wa Tomodachi ga Sekai',
    streamer: 'OmckTV Classic',
    title: 'No Stream No Life',
    official: true
  },
  {
    channel: 'hdgames',
    live: false,
    viewers: 0,
    service: 'hd',
    game: 'Boku Wa Tomodachi ga Sekai',
    streamer: 'OmckTV HD Games',
    title: 'OmckTV HD VideoGames Channel',
    official: true
  },
  {
    channel: 'hdkinco',
    live: false,
    viewers: 0,
    service: 'hd',
    game: 'Boku Wa Tomodachi ga Sekai',
    streamer: 'OmckTV HD Kinco',
    title: 'OmckTV HD Kinco Channel',
    official: true
  },
  {
    channel: 'omcktv',
    live: false,
    viewers: 0,
    service: 'twitch',
    game: 'Boku Wa Tomodachi ga Sekai',
    streamer: 'OmckTV Twitch',
    title: 'OmckTV Twitch',
    official: true
  },
  {
    channel: 'twitchplayspokemon',
    live: false,
    viewers: 0,
    service: 'twitch',
    game: 'Boku Wa Tomodachi ga Sekai',
    streamer: 'twitchplayspokemon',
    title: 'OmckTV Twitch',
    official: false
  }])
User.create([
  {
            twitter_id: "361122700",
            screen_name: "omckws",
            profile_image_url: "http://pbs.twimg.com/profile_images/50108201762304...",
            name: "Peer on Puma Hyper ",
            gmod: 1,
            streamer: 1
    },
    {
            twitter_id: "1423600716",
            screen_name: "ShineWitter",
            profile_image_url: "http://pbs.twimg.com/profile_images/378800000297104089/818e06f5634e647cea42f9d98ce92c08_normal.jpeg",
            name: "Witter Shine",
            gmod: 0,
            hd_channel: "",
            streamer: 0
        },
        {
            twitter_id: "953869526",
            screen_name: "OmckTV",
            profile_image_url: "http://pbs.twimg.com/profile_images/378800000297104089/818e06f5634e647cea42f9d98ce92c08_normal.jpeg",
            name: "OmckTV Live Updater",
            gmod: 0,
            hd_channel: "",
            streamer: 0
            }])
Key.create([{
  user_id: "1",
  key: "420MLG",
  guest: false
  },
  {
    user_id: "1",
    key: "420SkuR2",
    guest: true,
    streamer: "Guest",
    game: "Spurdo Sparde"
    }])
