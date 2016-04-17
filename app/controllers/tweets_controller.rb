class TweetsController < ApplicationController
  before_action :check_auth

  def tweet
    tweet = Tweet.new(comment: tweet_params[:comment], user_id: @current_user.id)

    unless tweet.nil?
      authorize tweet
      tweet.comment = extract_url(tweet.comment)
    end

    if tweet.save
      tclient.update( tweet.comment )
      render json: tweet
    else
      render json: {error: true, message: tweet.errors}
    end
  end

  def list
    tweets = Tweet.order(:id).last(10)
    render json: tweets
  end

  private

    def extract_url(comment="")
      links = extract_urls(comment)
      links.each {|link| comment.gsub! link, bitly.shorten(link).short_url}
      return comment
    end

end
