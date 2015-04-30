class Video < ActiveRecord::Base
  belongs_to :key
  belongs_to :user
  validates :uid, presence: true, uniqueness: true

  scope :deleted, -> { where(deleted: true) }

end
