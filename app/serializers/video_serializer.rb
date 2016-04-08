class VideoSerializer < ActiveModel::Serializer
  attributes :user_id, :key_id, :game, :description, :token, :path, :deleted, :created_at, :updated_at
end
