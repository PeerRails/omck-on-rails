class Stream < ActiveRecord::Base
  belongs_to :key
  belongs_to :user
  belongs_to :channel

  def stop!(date=DateTime.now)
  	raise self.ended_at.inspect
  	if self.ended_at.nil?
  	  self.update(date)
  	  return true
  	else
  	  self.errors[:ended_at] = "It was already stopped"
  	  return false
  	end
  end
end
