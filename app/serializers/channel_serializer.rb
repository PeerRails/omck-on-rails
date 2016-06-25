class ChannelSerializer < ActiveModel::Serializer
  attributes :channel, :viewers, :live, :game, :title, :streamer, :service, :official, :url, :player

  #has_many :keys
  #has_many :tweets
  #has_many :sessions
  #has_many :videos
  #has_many :api_token

  def url
    case self.service
    when 'hd'
      "http://omck.tv/#/channel/hd/#{self.channel}"
    when 'twitch'
      "http://twitch.tv/#{self.channel}"
    end
  end

  def player
    case self.service
    when 'hd'
      "/player?channel=#{self.channel}"
    when 'twitch'
      "http://player.twitch.tv/?channel=#{self.channel}"
    end
  end

end
