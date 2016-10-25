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



class User < ApplicationRecord
  has_many :keys
  has_many :tweets
  has_many :sessions
  has_many :videos
  has_many :api_token
  has_many :streams

  validates :twitter_id, presence: true, uniqueness: true

  scope :staff, -> { where('streamer = 1 or gmod = 1') }

  after_create :create_keys

  def self.login_with_twitter(omniauth)
    user = User.where(twitter_id: omniauth[:uid]).first_or_initialize do |u|
      u.twitter_id = omniauth[:uid]
      u.screen_name = omniauth[:info][:nickname]
    end
    user.update(  name: omniauth[:info][:name],
                  screen_name: omniauth[:info][:nickname],
                  profile_image_url: omniauth[:info][:image],
                  access_token: omniauth[:credentials][:token],
                  secret_token: omniauth[:credentials][:secret])
    user
  end

  def token
    ApiToken.where(user_id: self.id).where("expires_at > ?", DateTime.now).first
  end

  private
  def create_keys
    Key.create(user_id: self.id, key: SecureRandom.uuid, created_by: self.id)
    ApiToken.create(user_id: self.id)
  end
end
