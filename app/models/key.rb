class Key < ActiveRecord::Base
  belongs_to :users
  validates :key, :expires, :streamer, :presence => true
  scope :present, -> { where("expires > ?", DateTime.now) }
  scope :expired, -> { where("expires <= ?", DateTime.now) }
  scope :is_guest, -> { where(guest: true) }
  scope :streamers, -> { where(guest: false) }
end
