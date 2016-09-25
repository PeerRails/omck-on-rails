# == Schema Information
#
# Table name: streams
#
#  id         :integer          not null, primary key
#  key_id     :integer
#  user_id    :integer
#  channel_id :integer
#  game       :string
#  movie      :string
#  streamer   :string
#  ended_at   :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
