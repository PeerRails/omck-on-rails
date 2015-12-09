class User < ActiveRecord::Base
  has_many :keys
  has_many :tweets
  has_many :sessions
  has_many :videos
  validates :twitter_id, presence: true, uniqueness: true
  devise :rememberable, :omniauthable, omniauth_providers: [:twitter]

  scope :staff, -> { where('streamer = 1 or gmod = 1') }

  def self.login_with_twitter(omniauth)
    unless omniauth.nil?
      user = User.where(twitter_id: omniauth[:uid]).first_or_create do |user|
        user.twitter_id = omniauth[:uid]
        user.screen_name = omniauth[:info][:nickname]
      end
      user = update(user.id,
                    name: omniauth[:info][:name],
                    screen_name: omniauth[:info][:nickname],
                    profile_image_url: omniauth[:info][:image],
                    access_token: omniauth[:credentials][:token],
                    secret_token: omniauth[:credentials][:secret])
      return user
    else
      return nil
    end
  end
end
