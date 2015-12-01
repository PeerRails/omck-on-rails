class Channel < ActiveRecord::Base
  validates :channel, presence: true
  validates_format_of :channel, :with => /\A[a-zA-Z\d -_]*\z/i,
                                :message => "Только латиница и числа!"
  validates :streamer, presence: true

  scope :live, -> { where(live: 'true') }
  scope :not_live, -> { where(live: 'false') }
  scope :official, -> { where(official: true)}
  scope :twitch, -> { where(service: 'twitch') }
  #scope :hitbox, -> { where(service: 'hitbox') }
  scope :hd, -> { where(service: 'hd')}

end
