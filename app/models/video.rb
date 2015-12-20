class Video < ActiveRecord::Base
  belongs_to :key
  belongs_to :user
  validates :token, presence: true, uniqueness: true

  scope :deleted, -> { where(deleted: true) }
  scope :list, -> { select("token, game, deleted, description, path, created_at").where(deleted: false) }

end
