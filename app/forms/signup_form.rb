class SignupForm
  include ActiveModel::Model

  attr_accessor(
    :nickname,
    :password,
    :confirm_password,
    :email
  )

  validates :nickname, presence: true
  validates :nickname, format: { with: /[-_a-zA-Z0-9]/ }
  validates :nickname,  length: { in: 5..32 }
  validates :email, presence: false
  validates :password, presence: true
  validates :password, length: {in: 6..64}
  validates :confirm_password, presence: true

  validate :password_ok, :unique_nickname, :unique_email

  def password_ok
    errors.add(:confirm_password, "Doesn't match") unless password === confirm_password
  end

  def unique_nickname
    errors.add(:nickname, "already taken") unless Client.where(nickname: nickname).count == 0
  end

  def unique_email
    errors.add(:email, "already taken") unless Client.where(email: email).count == 0
  end


  def signup
    if valid?
      create_client
    end
  end

  private
    def create_client
      Client.create(nickname: nickname, password: password, email: email)
    end
end

