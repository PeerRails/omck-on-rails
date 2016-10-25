# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  twitter_id          :string
#  screen_name         :string           default("Null"), not null
#  profile_image_url   :string
#  name                :string           default("Anon")
#  gmod                :integer          default(0), not null
#  streamer            :integer          default(0), not null
#  login_last          :date
#  last_ip             :inet
#  access_token        :string
#  secret_token        :string
#  created_at          :datetime
#  updated_at          :datetime
#  remember_created_at :datetime
#  remember_token      :string
#  sign_in_count       :integer          default(0)
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string
#  last_sign_in_ip     :string
#


class UserSerializer < ActiveModel::Serializer
  attributes :id, :twitter_id, :name, :screen_name, :streamer, :gmod, :profile_image_url, :keys

  # Return present user's key
  # @return [Array<Key>]
  def keys
    object.keys.present.map do |key|
      KeySerializer.new(key, scope: scope, root: false)
    end
  end

  # Return boolean value of streamer field
  # @return [Boolean]
  def streamer
    object.streamer == 1 ? true : false
  end

  # Return boolean value of gmod field
  # @return [Boolean]
  def gmod
    object.gmod == 1 ? true : false
  end

end
