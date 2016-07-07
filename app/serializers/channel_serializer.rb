class ChannelSerializer < ActiveModel::Serializer
  attributes :channel, :viewers, :live, :game, :title, :streamer, :service, :official, :url, :player

  #has_many :keys
  #has_many :tweets
  #has_many :sessions
  #has_many :videos
  #has_many :api_token

  def url
    case object.service
    when 'hd'
      "http://omck.tv/#/channel/hd/#{object.channel}"
    when 'twitch'
      "http://twitch.tv/#{object.channel}"
    end
  end

  def player
    case object.service
    when 'hd'
      "/player?channel=#{object.channel}"
    when 'twitch'
      "http://player.twitch.tv/?channel=#{object.channel}"
    end
  end

end
