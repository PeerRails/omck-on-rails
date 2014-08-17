class Key < ActiveRecord::Base
  belongs_to :users
  validates :key, :expires, :streamer, :presence => true
  validate :uid, :unique => true, :except => 0
  scope :present, -> { where("expires >= ?", DateTime.now) }
  scope :expired, -> { where("expires < ?", DateTime.now) }
end
