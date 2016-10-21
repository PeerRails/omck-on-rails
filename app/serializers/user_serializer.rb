# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  twitter_id          :string(255)
#  screen_name         :string(255)      not null
#  profile_image_url   :string(255)      default("")
#  name                :string(255)      default("Anon")
#  login_last          :date
#  last_ip             :inet
#  access_token        :string(255)
#  secret_token        :string(255)
#  gmod                :integer          default(0), not null
#  hd_channel          :string(255)      default("0"), not null
#  streamer            :integer          default(0), not null
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
