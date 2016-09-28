# == Schema Information
#
# Table name: streams
#
#  id         :integer          not null, primary key
#  key_id     :integer
#  user_id    :integer
#  channel_id :integer
#  game       :string
#  movie      :string
#  streamer   :string
#  ended_at   :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# == JSON scheme
#    {
#        "stream": {
#            "id":               Integer,
#            "user_id":          Integer,
#            "key_id":           Integer,
#            "channel_id":       Integer,
#            "game":             String,
#            "created_at":       Date,
#            "ended_at":         Date
#        }
#    }

class StreamSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :key_id, :channel_id, :game, :created_at, :ended_at, :channel, :service, :username

  # Return Channel name
  # @return [String]
  def channel
      channel_obj.channel
  end

  # Return Channel service
  # @return [String]
  def service
      channel_obj.service
  end

  # Return User name
  # @return [String]
  def username
      user_obj.name
  end

  private
  # Return channel object by channel id
  # @return [Channel]
  def channel_obj
      Channel.select(:channel, :service).find(object.channel_id) || Channel.new(service: "Not Found", channel: "Not Found")
  end

  # Return user object by user id
  # @return [Channel]
  def user_obj
      User.select(:name).find(object.user_id) || User.new(name: "Not Found")
  end

end
