# == Schema Information
#
# Table name: streams
#
#  id         :integer          not null, primary key
#  key_id     :integer          not null
#  user_id    :integer          not null
#  channel_id :integer          not null
#  game       :string
#  movie      :string
#  streamer   :string
#  ended_at   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


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
      Channel.select(:channel, :service).where(id: object.channel_id).last || Channel.new(service: "Not Found", channel: "Not Found")
  end

  # Return user object by user id
  # @return [Channel]
  def user_obj
      User.select(:name).where(id: object.user_id).last || User.new(name: "Not Found")
  end

end
