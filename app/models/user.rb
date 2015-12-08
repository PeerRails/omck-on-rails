class User < ActiveRecord::Base
  has_many :keys
  has_many :tweets
  has_many :sessions
  has_many :videos
  validates :twitter_id, presence: true, uniqueness: true
  devise :rememberable, :omniauthable, omniauth_providers: [:twitter]

  scope :staff, -> { where('streamer = 1 or gmod = 1') }

  def self.login(omniauth)
    if !omniauth.nil?
    	return User.where(twitter_id: omniauth[:uid]).first_or_create do |user|
        user.twitter_id = omniauth[:uid]
        user.name = omniauth[:info][:name]
        user.screen_name = omniauth[:info][:nickname]
        user.profile_image_url = omniauth[:info][:image]
        user.access_token = omniauth[:credentials][:token]
        user.secret_token = omniauth[:credentials][:secret]
    	end
    else
      return nil
    end
  end

end
