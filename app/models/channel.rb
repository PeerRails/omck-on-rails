class Channel < ActiveRecord::Base
  validates :channel, presence: true, uniqueness: true
  #validates :service, presence: true
  #validate :service, inclusion: { in: %w(hdstream twitch classic),
  #  message: "%{value} Неправильный сервис стрима!" }
  validates :streamer, presence: true
end
