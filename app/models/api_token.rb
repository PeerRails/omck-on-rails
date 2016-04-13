class ApiToken < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, on: :create
  validates_uniqueness_of :secret
  scope :present, -> { where("expires_at > ?", DateTime.now).first }
  scope :expired, -> { where("expires_at <= ?", DateTime.now) }
  before_create :default_vals

  def default_vals
    self.secret = SecureRandom.hex(6)
    self.expires_at = DateTime.now + 99
  end

end
