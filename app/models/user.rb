class User < ActiveRecord::Base
  has_many :keys
  has_many :tweets
  has_many :sessions
  validates :twitter_id, presence: true, uniqueness: true

  scope :staff, -> { where('streamer = 1 or gmod = 1') }

  def self.login(omniauth)
    
  end

end
