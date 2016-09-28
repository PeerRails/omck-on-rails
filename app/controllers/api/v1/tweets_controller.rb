module Api
  module V1

    # API Tweet Controller
    # Class for managing tweets
    class TweetsController < ApiApplicationController
      include Twitter::Extractor
      load_and_authorize_resource

      # Returns all tweets
      #
      # GET api/v1/tweets
      # @return [Array<TweetSerializer>]
      # @todo add pagination
      def list
        #page = params[:page].nil? ? 0 : params[:page]
        tweets = Tweet.all
        render json: tweets
      end

      # Returns required tweet
      #
      # GET api/v1/tweets/:id
      # @return [TweetSerializer]
      def show
        tweet = Tweet.find(params[:id])
        render json: tweet
      end

      # Returns tweets by queried user
      #
      # GET api/v1/tweets/user/:user_id
      # @return [Array<TweetSerializer>]
      # @todo add pagination
      def by_user
        tweets = Tweet.where(user_id: params[:user_id])
        render json: tweets
      end

      # Creates tweet
      #
      # POST api/v1/tweets/post
      # @see tweet_params #tweet_params for queried fields
      # @return [TweetSerializer]
      # @raise [{error: true, message: tweet.errors}]
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

      # Deletes tweet
      #
      # DELETE api/v1/tweets/:id/delete
      # @return [{error: nil, message: "Deleted!"}]
      # @raise [{error: true, message: tweet.errors}]
      def delete
        tweet = Tweet.find(params[:id])
        if tweet.destroy
          render json: {error: nil, message: "Deleted!"}
        else
          render json: {error: true, message: tweet.errors}
        end
      end

      private
      # @!visibility public
      # Private method to convert urls to bitly. 
      # @note With new twitter update I don't know do I really need this
      # @param comment [String] Text of tweet
      # @return [String] Updated Text
      def extract_url(comment)
        links = extract_urls(comment)
        links.each {|link| comment.gsub! link, bitly.shorten(link).short_url}
        return comment
      end

      # @!visibility public
      # Strong parameters for quering tweets, requires namespace 'tweet'
      #
      # @param _opts [Hash] Namespace 'tweet'
      # @option _opts [Integer] :comment - Tweet text
      # @option _opts [Integer] :own - Not sure if I need this
      # @return [Hash]
      def tweet_params(_opts={})
        params.require(:tweet).permit(:comment, :own)
      end
    end
  end
end
