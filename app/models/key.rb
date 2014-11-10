class Key < ActiveRecord::Base
  belongs_to :users, foreign_key: "uid"
  validates :key, :expires, :streamer, :presence => true
  validate :uid, :except => 0
  scope :present, -> { where("expires > ?", DateTime.now) }
  scope :expired, -> { where("expires <= ?", DateTime.now) }
  scope :guests, -> { where(guest: true) }
  scope :streamers, -> { where(guest: false) }
end
