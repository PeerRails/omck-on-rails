class TweetPolicy < ApplicationPolicy

  def tweet?
    streamer? or admin?
  end

  def tweet
    @record
  end

end