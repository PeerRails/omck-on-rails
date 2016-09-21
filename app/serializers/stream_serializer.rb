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

class StreamSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :key_id, :channel_id, :game, :created_at, :ended_at

end
