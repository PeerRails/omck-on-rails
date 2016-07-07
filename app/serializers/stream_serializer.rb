class StreamSerializer < ActiveModel::Serializer
  attributes :user_id, :key_id, :channel_id, :game, :created_at, :ended_at

end
