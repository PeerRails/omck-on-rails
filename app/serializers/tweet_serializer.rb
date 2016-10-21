# == Schema Information
#
# Table name: tweets
#
#  id         :integer          not null, primary key
#  user_id    :integer          default(1), not null
#  comment    :text             not null
#  created_at :datetime
#  updated_at :datetime
#


class TweetSerializer < ActiveModel::Serializer
  attributes :id, :comment, :created_at

  has_one :user
end
