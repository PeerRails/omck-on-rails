class Stream < ActiveRecord::Base
  belongs_to :key
  belongs_to :user
  belongs_to :channel

  validates :key_id, :user_id, :channel_id, :presence => true

  def stop!(date=Time.now)
  	if self.ended_at.nil?
  	  self.update(ended_at: date)
  	  return true
  	else
  	  return false
  	end
  end
end
