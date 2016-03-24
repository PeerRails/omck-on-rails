class Key < ActiveRecord::Base
  belongs_to :user
  has_many :videos
  validates :expires, :streamer, :presence => true
  validates :key, uniqueness: true
  scope :present, -> { where("expires > ?", DateTime.now).where(guest: false) }
  scope :expired, -> { where("expires <= ?", DateTime.now) }
  scope :is_guest, -> { where("expires > ?", DateTime.now).where(guest: true) }
  scope :streamers, -> { where(guest: false) }

  before_create :generate_key

  def generate_key
    self.key = SecureRandom.uuid if self.key.nil?
  end
end
