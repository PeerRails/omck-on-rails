class Tweet < ActiveRecord::Base
  belongs_to :user
  validates :comment, :presence => {message: "Поле не должны быть пустыми!"}, allow_blank: false
  validates :comment, :length => {maximum: 140}
  attr_accessor :own

end
