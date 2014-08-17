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
    title: 'No Stream No Life'
  },
  {
    channel: 'hdgames',
    live: false,
    viewers: 0,
    service: 'hd',
    game: 'Boku Wa Tomodachi ga Sekai',
    streamer: 'OmckTV HD Games',
    title: 'OmckTV HD VideoGames Channel'
  },
  {
    channel: 'hdkinco',
    live: false,
    viewers: 0,
    service: 'hd',
    game: 'Boku Wa Tomodachi ga Sekai',
    streamer: 'OmckTV HD Kinco',
    title: 'OmckTV HD Kinco Channel'
  },
  {
    channel: 'hdkinco',
    live: false,
    viewers: 0,
    service: 'twitch',
    game: 'Boku Wa Tomodachi ga Sekai',
    streamer: 'OmckTV Twitch',
    title: 'OmckTV Twitch'
  }])
