class ApiToken < ActiveRecord::Base
  belongs_to :user
  validates :secret, :expires_at, :user_id, :presence => true
  validates :secret, uniqueness: true
  scope :present, -> { where("expires_at > ?", DateTime.now).first }
  scope :expired, -> { where("expires_at <= ?", DateTime.now) }
end
