module Api
  module V1
    class TweetsController < ApiApplicationController
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
        tweet = Tweet.new(tweet_params, user_id: @current_user.id)
        if tclient.update( tweet.comment )
          tweet.save
          render json: tweet
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

      def tweet_params
        params.require(:tweet).permit(:comment, :own)
      end
    end
  end
end
