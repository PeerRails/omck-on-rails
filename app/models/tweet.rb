class Tweet < ActiveRecord::Base
  belongs_to :user
  validates :comment, :presence => {message: "Твит не должен быть пустым!"}, allow_blank: false
  validates :comment, :length => {maximum: 140}
  attr_accessor :own

end
