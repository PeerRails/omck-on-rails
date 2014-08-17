class Tweet < ActiveRecord::Base
  validate :comment, :tipe, :presence => {message: "Поля не должны быть пустыми!"}, allow_blank: false
  validate :comment, :length => {maximum: 140}
end
