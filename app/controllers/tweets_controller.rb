class TweetsController < ApplicationController
  before_action :check_auth, only: [:tweet]
  include Twitter::Extractor

  def tweet
    tweet = Tweet.new(comment: tweet_params[:comment], user_id: @current_user.id)

    unless tweet.nil?
      authorize tweet
      tweet.comment = extract_link(tweet.comment)
    end

    if tweet.save
      tclient.update( tweet.comment )
      render json: tweet
    else
      render json: {error: true, message: tweet.errors}
    end
  end

  def list
    tweets = Tweet.order("id asc").last(5)
    render json: tweets
  end

  private

    def extract_link(comment="")
      links = extract_urls(comment)
      links.each {|link| comment.gsub! link, bitly.shorten(link).short_url}
      return comment
    end

    def tweet_params
      params.require(:tweet).permit(:comment)
    end

end
