class UserSerializer < ActiveModel::Serializer
  attributes :id, :twitter_id, :name, :screen_name, :profile_image_url, :streamer, :gmod, :keys

  #has_many :keys
  #has_many :tweets
  #has_many :sessions
  #has_many :videos
  #has_many :api_token

  def keys
    object.keys.present.map do |key|
      KeySerializer.new(key, scope: scope, root: false)
    end
  end

end
