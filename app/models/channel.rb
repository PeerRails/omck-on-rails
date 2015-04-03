class Channel < ActiveRecord::Base
  validates :channel, presence: true
  validates :channel, uniqueness: { scope: :service,
    message: "Подобный канал на сервисе уже есть!" }
  validates_format_of :channel, :with => /\A[a-zA-Z\d -_]*\z/i,
                                :message => "Только латиница и числа!"
  #validates :service, presence: true
  #validate :service, inclusion: { in: %w(hdstream twitch classic),
  #  message: "%{value} Неправильный сервис стрима!" }
  validates :streamer, presence: true

  scope :live, -> { where(live: 'true') }
  scope :not_live, -> { where(live: 'false') }
  scope :official, -> { where(official: true)}
  scope :find_twitch, -> { where(service: 'twitch') }
  scope :find_hitbox, -> { where(service: 'hitbox') }
  scope :find_hd, -> { where(service: 'hd')}

end
