class Channel < ActiveRecord::Base
  validates :channel, presence: true, uniqueness: true
  #validates :service, presence: true
  #validate :service, inclusion: { in: %w(hdstream twitch classic),
  #  message: "%{value} Неправильный сервис стрима!" }
  validates :streamer, presence: true

  scope :live, -> { where(live: 'true') }
  scope :not_live, -> { where(live: 'false') }
  scope :find_twitch, -> { where(service: 'twitch') }
  scope :find_hitbox, -> { where(service: 'hitbox') }
  scope :find_hd, -> { where(service: 'hd')}
end
