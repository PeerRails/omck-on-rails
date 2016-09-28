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
# == JSON scheme
#    {
#        "tweet": {
#            "id":          Integer,
#            "comment":     String,
#            "created_at":  Date,
#            "user": {
#                "id":                  Integer,
#                "twitter_id":          String,
#                "name":                String,
#                "screen_name":         String,
#                "streamer":            Boolean,
#                "gmod":                Boolean,
#                "profile_image_url":   String,
#                "keys": [
#                    {
#                        "id":                      Integer,
#                        "streamer":                String,
#                        "movie":                   String,
#                        "game":                    String,
#                        "guest":                   Boolean,
#                        "expires":                 Date,
#                        "created_by":              Integer,
#                        "created_by_name":         String,
#                        "created_by_screen_name":  String,
#                        "user_id":                 Integer
#                    }
#                ]
#            }
#        }
#    }

class TweetSerializer < ActiveModel::Serializer
  attributes :id, :comment, :created_at

  has_one :user
end
