module Api
  module V1

    # API User Controller
    # Class for managing users
    class UsersController < ApiApplicationController
      load_and_authorize_resource

      # Returns all users
      #
      # GET api/v1/users
      # @return [Array<UserSerializer>]
      # @todo add pagination
      def list
        users = User.all
        render json: users
      end

      # Returns required user
      #
      # GET api/v1/user/:id
      # @return [UserSerializer]
      def show
        user = User.find(params[:id])
        if user.nil?
          render json: {error: true, message: "User not found"}
        else
          render json: user
        end
      end

      # Returns videos by user id
      #
      # GET api/v1/user/:id/videos
      # @return [Array<VideoSerializer>]
      # @raise [{error: true, message: "User or Videos not found"}]
      # @todo add pagination
      def videos
        user = User.find(params[:id])
        if user.nil?
          render json: {error: true, message: "User or Videos not found"}
        else
          render json: user.videos, each_serializer: VideoSerializer, root: "videos"
        end
      end

      # Updates required user
      #
      # POST api/v1/user/:id/update
      # @see user_params #user_params for updating fields
      # @return [UserSerializer]
      # @raise [{error: true, message: user.errors}]
      def update
        user = User.find(params[:id])
        user.update(user_params)
        if user.save
          render json: user
        else
          render json: {error: true, message: user.errors}
        end
      end

      # Grants permissions to required user
      #
      # POST api/v1/user/:id/grant
      # @see grant_params #grant_params for updating fields
      # @return [UserSerializer]
      # @raise [{error: true, message: user.errors}]
      def grant
        user = User.find(params[:id])
        user.update(grant_params)
        if user.save
          render json: user
        else
          render json: {error: true, message: user.errors}
        end
      end

      # Creates or updates user by inviting through twitter account
      #
      # POST api/v1/user/:id/invite
      # @see user_params #user_params for queried fields
      # @return [UserSerializer]
      # @raise [{error: true, message: user.errors}]
      def invite
        account = tclient.user(user_params[:screen_name], :skip_status => true)
        user = User.find_or_create_by(twitter_id: account.id) do |u|
          u.twitter_id = account.id
          u.screen_name = account.screen_name
          u.name = account.name
        end
        #authorize user
        if user.update(streamer: 1)
          render json: user
        else
          render json: {error: true, message: user.errors}
        end
      end

      private
      # @!visibility public
      # Strong parameters for quering user, requires namespace 'user'
      #
      # @param _opts [Hash] Namespace 'user'
      # @option _opts [String] :screen_name - twitter account name (with @)
      # @option _opts [String] :name - user name
      # @option _opts [String] :profile_image_url - profile image from twitter
      # @return [Hash]
      def user_params(_opts={})
        params.require(:user).permit(:screen_name, :name, :profile_image_url)
      end

      # @!visibility public
      # Strong parameters for granting permissions to user, requires namespace 'user'
      #
      # @param _opts [Hash] Namespace 'user'
      # @option _opts [Integer] :streamer - 1 for granting streamer perm, 0 for denying
      # @option _opts [Integer] :gmod - 1 for granting gmod perm, 0 for denying
      # @return [Hash]
      def grant_params(_opts={})
        params.require(:user).permit(:streamer, :gmod)
      end
    end
  end
end
