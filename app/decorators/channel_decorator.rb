class ChannelDecorator < Draper::Decorator
  delegate_all

  def url
    case object.service
    when 'hd'
      "http://omck.tv/#/channel/hd/#{object.channel}"
    when
      "https://twitch.tv/#{object.channel}"
    end
  end

  def player
    case object.service
    when 'hd'
      "/player?channel=#{object.channel}"
    when 'twitch'
      "https://player.twitch.tv/?channel=#{object.channel}"
    end
  end
end
