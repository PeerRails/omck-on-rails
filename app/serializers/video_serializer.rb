class VideoSerializer < ActiveModel::Serializer
  attributes :user_id, :key_id, :game, :description, :token, :path, :deleted, :created_at, :updated_at, :username

  def username
    Key.find(object.key_id).streamer
  end
end
