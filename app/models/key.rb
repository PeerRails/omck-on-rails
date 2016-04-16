class Key < ActiveRecord::Base
  belongs_to :user
  has_many :videos
  validates :expires, :streamer, :presence => true
  validates :key, uniqueness: true
  validates :streamer, length: { minimum: 3, maximum: 40, message: "Имя стримера должно быть более 3 и менее 40 символов " }
  validates :game, length: { minimum: 3, maximum: 40, message: "Название игры должно быть более 3 и менее 40 символов " }
  validates :movie, length: { minimum: 3, maximum: 40, message: "Название кинца должно быть более 3 и менее 40 символов " }
  validate :key_limit, on: :create
  scope :present, -> { where("expires > ?", DateTime.now).where(guest: false) }
  scope :expired, -> { where("expires <= ?", DateTime.now) }
  scope :is_guest, -> { where("expires > ?", DateTime.now).where(guest: true) }

  before_create :generate_key, :make_created_by

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
    if Key.where(user_id: self.user_id).present.count > 0 && !self.guest
      self.errors[:key] << "Рабочий ключ уже существует."
    end
  end
end
