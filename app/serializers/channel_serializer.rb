class ChannelSerializer < ActiveModel::Serializer
  attributes :channel, :viewers, :live, :game, :title, :streamer, :service, :official, :url

  #has_many :keys
  #has_many :tweets
  #has_many :sessions
  #has_many :videos
  #has_many :api_token
  def url
    case self.service
    when 'hd'
      "http://player.omck.tv/hd/#{self.channel}"
    when 'twitch'
      "http://twitch.tv/#{self.channel}"
    end

  end
end
