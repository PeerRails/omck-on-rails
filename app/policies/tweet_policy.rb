# Policy for API Tweet
class TweetPolicy < ApplicationPolicy

  # Show if user can tweet
  # @return [Boolean]
  def tweet?
    streamer? or admin?
  end

  # Define record
  # @return [Tweet]
  def tweet
    @record
  end

end
