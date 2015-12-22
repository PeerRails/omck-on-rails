class Key < ActiveRecord::Base
  belongs_to :user
  has_many :videos
  validates :key, :expires, :streamer, :presence => true
  validates :key, uniqueness: true
  scope :present, -> { where("expires > ?", DateTime.now).where(guest: false) }
  scope :expired, -> { where("expires <= ?", DateTime.now) }
  scope :is_guest, -> { where(guest: true) }
  scope :streamers, -> { where(guest: false) }
end
