class Tweet < ActiveRecord::Base
  before_create :let_me_tweet
  belongs_to :user
  validates :comment, :presence => {message: "Поле не должны быть пустыми!"}, allow_blank: false
  validates :comment, :length => {maximum: 140}
  attr_accessor :own

  def let_me_tweet
    if self.own == 0
      self.comment = "Стрим на #omcktv || " + self.comment
    end
    TClient.tclient.update( self.comment )
  end
end
