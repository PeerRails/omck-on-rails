class ApiToken < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :presence => true
  validates :secret, uniqueness: true
  validate :check_user
  scope :present, -> { where("expires_at > ?", DateTime.now).first }
  scope :expired, -> { where("expires_at <= ?", DateTime.now) }
  before_create :default_vals

  def check_user
    token = ApiToken.where(user_id: self.user_id).where("expires_at > ?", DateTime.now)
    unless token.empty?
      self.errors[:user_id] << "Рабочий токен уже существует."
    end
  end

  def default_vals
    self.secret = SecureRandom.hex(6)
    self.expires_at = DateTime.now + 99
  end

end
