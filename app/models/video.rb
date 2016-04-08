class Video < ActiveRecord::Base
  belongs_to :key
  belongs_to :user

  scope :deleted, -> { where(deleted: true) }
  scope :list, -> { select("token, game, deleted, description, path, user_id, key_id, created_at, updated_at").where(deleted: false) }

  before_create :create_token

  def create_token
    self.token = SecureRandom.urlsafe_base64(6)
  end

end
