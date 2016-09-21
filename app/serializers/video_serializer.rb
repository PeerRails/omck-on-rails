# == Schema Information
#
# Table name: videos
#
#  id          :integer          not null, primary key
#  game        :string           default("Boku no Pico"), not null
#  user_id     :integer
#  key_id      :integer
#  youtube_id  :string
#  description :text             default("Boku no Pico")
#  token       :string           not null
#  path        :string
#  deleted     :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class VideoSerializer < ActiveModel::Serializer
  attributes :user_id, :key_id, :game, :description, :token, :deleted, :created_at, :updated_at, :username

  def username
    Key.find(object.key_id).streamer
  end
end
