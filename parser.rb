require 'kappa'
require 'pg'
require 'redis'
require 'open-uri'
require "json"
require "addressable/uri"
require 'uri'
require 'active_record'

class URI::Parser
  def split url
    a = Addressable::URI::parse url
    [a.scheme, a.userinfo, a.host, a.port, nil, a.path, nil, a.query, a.fragment]
  end
end

ActiveRecord::Base.establish_connection(
  ENV["DATABASE_URL"]
)

class Channel < ActiveRecord::Base
  self.table_name = 'channels'
end


redis = Redis.new(:url => (ENV["REDIS_URL"] || 'redis://127.0.0.1:6379'))
live = redis.lrange("live_channel_list", 0, -1)

Twitch.configure do |config|
     config.client_id = ENV["TWITCH_ID"]
end

res = Channel.where(service: 'twitch').to_a

list = []
new_list = []

res.each do |row|
  list << row.channel
end

page = "http://xmc_mc_mc_omckx.api.channel.livestream.com/2.0/info.json"
json = JSON.parse(open(page).read)
viewers = json['channel']['currentViewerCount']
game = json['channel']['description']
c_live = json['channel']['isLive'] || ""
puts "mc_mc_mc_omck #{c_live} #{viewers} w/ #{game}"

if c_live != ""
  new_list << "mc_mc_mc_omck"
end
res = Channel.find_by_channel('mc_mc_mc_omck')
res.update(viewers: viewers, live: c_live)
res.save
redis.set "viewers_mc_mc_mc_omck", viewers

Twitch.streams.find(channel: list) do |stream|
    redis.set "viewers_#{stream.channel.name}", stream.viewer_count
    puts stream
    new_list << stream.channel.name
    res = Channel.find_by_channel stream.channel.name
    res.update(game: stream.game_name, viewers: stream.viewer_count, title: stream.channel.status, live: true)
    res.save
end

if live.include? "hdkinco"
  new_list << "hdkinco"
end
if live.include? "hdgames"
  new_list << "hdgames"
end

puts "--old--"
puts live
puts "--new--"
puts new_list
redis.del "live_channel_list"
redis.rpush("live_channel_list", new_list) if !new_list.empty?
