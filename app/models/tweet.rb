class Tweet < ActiveRecord::Base
  before_create :let_me_tweet
  belongs_to :users
  validate :comment, :tipe, :presence => {message: "Поля не должны быть пустыми!"}, allow_blank: false
  validate :comment, :length => {maximum: 140}

  def let_me_tweet
    if self.tipe == 0
      self.comment = "Скоро домой" + self.comment
    end
    TClient.tclient.update( self.comment )
  end
end
