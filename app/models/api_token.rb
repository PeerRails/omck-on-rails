class ApiToken < ActiveRecord::Base
  belongs_to :user
  validates :secret, :expires_at, :user_id, :presence => true
  validates :secret, uniqueness: true
  validate :check_user
  scope :present, -> { where("expires_at > ?", DateTime.now).first }
  scope :expired, -> { where("expires_at <= ?", DateTime.now) }

  def check_user
    token = ApiToken.where(user_id: self.user_id).where("expires_at > ?", DateTime.now)
    unless token.empty?
      self.errors[:user_id] << "Рабочий токен уже существует."
    end
  end

end
