class Session < ActiveRecord::Base
  belongs_to :user
  validates :session_id, presence: true, uniqueness: true

end
