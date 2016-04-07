class Key < ActiveRecord::Base
  belongs_to :user
  has_many :videos
  validates :expires, :streamer, :presence => true
  validates :key, uniqueness: true
  scope :present, -> { where("expires > ?", DateTime.now).where(guest: false) }
  scope :expired, -> { where("expires <= ?", DateTime.now) }
  scope :is_guest, -> { where("expires > ?", DateTime.now).where(guest: true) }
  scope :streamers, -> { where(guest: false) }

  before_create :generate_key, :make_created_by, :key_limit

  def generate_key
    self.key = SecureRandom.uuid if self.key.nil?
  end

  def make_created_by
    self.created_by = self.user_id if self.created_by.nil?
  end

  def expire
    self.expires = DateTime.now
    self.save
  end

  def key_limit
    if Key.where(user_id: self.user_id).where("key != ?",key).present.count > 0 && !self.guest
      self.errors[:user_id] << "Рабочий ключ уже существует."
    end
  end
end
