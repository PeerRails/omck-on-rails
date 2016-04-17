class UserSerializer < ActiveModel::Serializer
  attributes :id, :twitter_id, :name, :screen_name, :streamer, :gmod, :profile_image_url, :keys

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

  def streamer
    object.streamer == 1 ? true : false
  end

  def gmod
    object.gmod == 1 ? true : false
  end

end
