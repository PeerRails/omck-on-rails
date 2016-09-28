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

class User < ActiveRecord::Base
  has_many :keys
  has_many :tweets
  has_many :sessions
  has_many :videos
  has_many :api_token
  has_many :streams
  validates :twitter_id, presence: true, uniqueness: true
  devise :rememberable, :omniauthable, omniauth_providers: [:twitter]

  scope :staff, -> { where('streamer = 1 or gmod = 1') }

  after_create :key_create

  def self.login_with_twitter(omniauth)
    unless omniauth.nil?
      user = User.where(twitter_id: omniauth[:uid]).first_or_create do |u|
        u.twitter_id = omniauth[:uid]
        u.screen_name = omniauth[:info][:nickname]
      end
      user.update(  name: omniauth[:info][:name],
                    screen_name: omniauth[:info][:nickname],
                    profile_image_url: omniauth[:info][:image],
                    access_token: omniauth[:credentials][:token],
                    secret_token: omniauth[:credentials][:secret])
      return user
    else
      return nil
    end
  end

  def token
    return ApiToken.where(user_id: self.id).where("expires_at > ?", DateTime.now).first
  end

  private
  def key_create
    Key.create(user_id: self.id, key: SecureRandom.uuid, created_by: self.id)
  end
end
