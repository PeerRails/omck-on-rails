# == Schema Information
#
# Table name: streams
#
#  id         :integer          not null, primary key
#  key_id     :integer          not null
#  user_id    :integer          not null
#  channel_id :integer          not null
#  game       :string
#  movie      :string
#  streamer   :string
#  ended_at   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :integer
#


class Stream < ActiveRecord::Base
  belongs_to :key
  belongs_to :client
  belongs_to :channel

  validates :key_id, :client_id, :channel_id, :presence => true

  def stop!(date=Time.now)
  	if self.ended_at.nil?
  	  self.update(ended_at: date)
  	  return true
  	else
  	  return false
  	end
  end
end
