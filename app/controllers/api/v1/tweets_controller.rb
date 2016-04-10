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

      def tweet_params
        params.require(:tweet).permit(:comment, :own)
      end
    end
  end
end
