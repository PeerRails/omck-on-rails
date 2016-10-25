# == Schema Information
#
# Table name: api_tokens
#
#  id         :integer          not null, primary key
#  secret     :string
#  user_id    :integer
#  expires_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :integer
#



class ApiToken < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id, on: :create
  validates_uniqueness_of :secret

  scope :present, -> { where("expires_at > ?", DateTime.now).first }
  scope :expired, -> { where("expires_at <= ?", DateTime.now) }

  before_create :default_vals

  def default_vals
    self.secret = SecureRandom.hex(6)
    self.expires_at = DateTime.now + 9999
  end

end
