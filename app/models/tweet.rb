# == Schema Information
#
# Table name: tweets
#
#  id         :integer          not null, primary key
#  user_id    :integer          default(1), not null
#  comment    :text             not null
#  created_at :datetime
#  updated_at :datetime
#  client_id  :integer
#


class Tweet < ActiveRecord::Base
  belongs_to :user
  validates :comment, :presence => {message: "Твит не должен быть пустым!"}, allow_blank: false
  validates :comment, :length => {maximum: 140}
  validates_presence_of :user_id, on: :create

end
