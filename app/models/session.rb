class Session < ActiveRecord::Base
  belongs_to :users
  validates :session_id, presence: true, uniqueness: true

end
