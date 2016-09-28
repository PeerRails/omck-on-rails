# coding: utf-8
module Api
  module V1
    # API Key Controller
    # Class for handling key requests
    class KeysController < ApiApplicationController
      load_and_authorize_resource

      # Returns current user's key
      #
      # GET api/v1/keys
      # @return [KeySerializer]
      def retrieve
        key = Key.present.where(user_id: @current_user.id).last
        if key.nil?
          new_key = Key.create(user_id: @current_user.id, guest: false, created_by: @current_user.id)
          render json: new_key, scope: current_user
        else
          render json: key
        end
      end

      # Returns all present keys
      #
      # GET api/v1/keys/all
      # @return [Array<KeySerializer>]
      def all
        keys = Key.present.order(:id)
        render json: keys
      end

      # Returns all guest present keys
      #
      # GET api/v1/keys/guest
      # @return [Array<KeySerializer>]
      def guest
        keys = Key.is_guest
        render json: keys
      end

      # Create key
      #
      # POST api/v1/keys/create
      # @return [KeySerializer]
      def create
        key = Key.new(key_params)
        if key.save
          render json: key
        else
          render json: { error: true, message: key.errors }
        end
      end

      # Create key
      #
      # @see key_params #key_params for query fields
      # POST api/v1/keys/create
      # @return [KeySerializer]
      def regenerate
        key = User.find(key_params[:user_id]).keys.present.last
        if key.expire
          new_key = Key.create(user_id: key.user_id, guest: false, streamer: key.streamer, game: key.game, movie: key.movie, created_by: @current_user.id)
          render json: new_key
        else
          render json: { error: true, message: key.errors }
        end
      end

      # Update required key
      #
      # @see key_params #key_params for query fields
      # @see key_params_update #key_params_update for editing fields
      # POST api/v1/keys/update
      # @return [KeySerializer]
      def update
        key = User.find(key_params[:user_id]).keys.present.last
        key.update(key_params_update)
        if key.save
          render json: key
        else
          render json: { error: true, message: key.errors }
        end
      end

      # Expire required key
      #
      # @see key_params #key_params for query fields
      # POST api/v1/keys/expire
      # @return [JSON]
      def expire
        key = User.find(key_params[:user_id]).keys.present.last
        if key.expire
          render json: { error: nil, message: "Ключ испарен!" }
        else
          render json: { error: true, message: key.errors }
        end
      end

      # Check if key is valid
      #
      # GET api/v1/keys/authorize
      # @return [KeySerializer]
      # @todo change to POST for better security
      def authorize
        key = Key.find_by_key(params[:key])
        if key.nil? or current_user.gmod == 0
            render json: { error: true, message: "Forbidden" }
        else
          render json: key
        end
      end

      private
      # @!visibility public
      # Strong parameters for creating keys, requires namespace 'key'
      #
      # @param _opts [Hash] Namespace 'key'
      # @option _opts [Integer] :user_id User Id
      # @option _opts [Boolean] :guest *optional* Guest key?
      # @option _opts [String] :streamer - *optional* Streamer name
      # @option _opts [String] :game - *optional* Game Title
      # @option _opts [Boolean] :movie - *optional* Movie Title
      def key_params(_opts={})
        params.require(:key).permit(:user_id, :guest, :streamer, :game, :movie)
      end

      # @!visibility public
      # Strong parameters for updating keys, requires namespace 'key'
      #
      # @param _opts [Hash] Namespace 'key'
      # @option _opts [String] :streamer - *optional* Streamer name
      # @option _opts [String] :game - *optional* Game Title
      # @option _opts [Boolean] :movie - *optional* Movie Title
      def key_params_update(_opts={})
        params.require(:key).permit(:streamer, :game, :movie)
      end
    end
  end
end
