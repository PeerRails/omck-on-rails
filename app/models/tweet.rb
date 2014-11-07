class Tweet < ActiveRecord::Base
  before_create :let_me_tweet
  belongs_to :users
  validate :comment, :tipe, :presence => {message: "Поля не должны быть пустыми!"}, allow_blank: false
  validate :comment, :length => {maximum: 140}

  def let_me_tweet
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TICKET_1"]
      config.consumer_secret     = ENV["TICKET_2"]
      config.access_token        = ENV["TICKET_3"]
      config.access_token_secret = ENV["TICKET_4"]
    end
    if self.tipe == 0
      self.comment = "Скоро домой" + self.comment
    end
    client.update( self.comment )
  end
end
