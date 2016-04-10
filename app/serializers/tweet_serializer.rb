class TweetSerializer < ActiveModel::Serializer
  attributes :id, :comment, :created_at

  has_one :user
end
