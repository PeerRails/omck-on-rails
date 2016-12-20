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



# == Serializer Information
# Return JSON object for Array
#    {"channels":
#      "id": Integer,
#      "channel": String,
#      "viewers": Integer,
#      "live": Boolean,
#      "game": String,
#      "title": String,
#      "streamer": String,
#      "service": String,
#      "official": Boolean,
#      "url": String,
#      "player": String
#    }
#
# For single channel response API returns with namespace *channel*


class ChannelSerializer < ActiveModel::Serializer
  attributes :id, :channel, :viewers, :live, :game, :title, :streamer, :service, :official, :url, :player

  # Return origin URL of channel
  # @return [String]
  def url
    case object.service
    when 'hd'
      "http://omck.tv/#/channel/hd/#{object.channel}"
    when 'twitch'
      "http://twitch.tv/#{object.channel}"
    #else
      #"Unknown Source"
    end
  end

  # Return URL of player with queryed channel
  # @return [String]
  def player
    case object.service
    when 'hd'
      "/player?channel=#{object.channel}"
    when 'twitch'
      "http://player.twitch.tv/?channel=#{object.channel}"
    #else
      #"Unknown Source"
    end
  end

end
