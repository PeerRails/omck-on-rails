module Api
  module V1
    class TweetsController < ApiApplicationController
      include Twitter::Extractor

      def list
        #page = params[:page].nil? ? 0 : params[:page]
        tweets = Tweet.all
        render json: tweets
      end

      def show
        tweet = Tweet.find(params[:id])
        render json: tweet
      end

      def by_user
        tweets = Tweet.where(user_id: params[:user_id])
        render json: tweets
      end

      def post
        tweet = Tweet.new(comment: tweet_params[:comment], user_id: @current_user.id)
        tweet.comment = extract_url(tweet.comment)
        if tweet.save
          tclient.update( tweet.comment )
          render json: tweet
        else
          render json: {error: true, message: tweet.errors}
        end
      end

      def delete
        tweet = Tweet.find(params[:id])
        if tweet.destroy
          render json: {error: nil, message: "Deleted!"}
        else
          render json: {error: true, message: tweet.errors}
        end
      end

      def extract_url(comment)
        links = extract_urls(comment)
        links.each {|link| comment.gsub! link, bitly.shorten(link).short_url}
        return comment
      end

      def tweet_params
        params.require(:tweet).permit(:comment, :own)
      end
    end
  end
end
