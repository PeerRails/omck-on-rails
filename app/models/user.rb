class User < ActiveRecord::Base
  has_many :keys, foreign_key: "uid"
  has_many :tweets, foreign_key: "uid"
end
