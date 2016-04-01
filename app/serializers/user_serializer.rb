class UserSerializer < ActiveModel::Serializer
  attributes :id, :twitter_id, :name, :screen_name, :profile_image_url, :streamer, :gmod, :key

  #has_many :keys
  #has_many :tweets
  #has_many :sessions
  #has_many :videos
  #has_many :api_token
  def key
    self.keys.present.last || nil
  end
end
