class User < ActiveRecord::Base
  has_many :keys, foreign_key: "uid"
  has_many :tweets, foreign_key: "uid"
  validates :twitter_id, presence: true, uniqueness: true

  scope :staff, -> { where('streamer = 1 or gmod = 1') }

end
