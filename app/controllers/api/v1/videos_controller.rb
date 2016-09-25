module Api
  module V1

    # API Video Controller
    # Class for managing videos
    class VideosController < ApiApplicationController
      load_and_authorize_resource

      # Returns all videos
      #
      #>GET api/v1/videos
      #>GET api/v1/videos/unarchived
      #>GET api/v1/videos/archive
      # @return [Array<VideoSerializer>]
      # @todo add pagination
      def list
        deleted = params[:deleted] == "true" ? true : false
        videos = Video.where(deleted: deleted)
        render json: videos
      end

      # Returns queried video
      #
      # GET api/v1/video/:token
      # @return [VideoSerializer]
      def show
        video = Video.find_by_token(params[:token])
        render json: video
      end

      # Create new video
      #
      # POST api/v1/videos/add
      # @see vid_params #vid_params for queried fields
      # @return [VideoSerializer]
      # @raise [{error: true, message: video.errors}]
      def add
        video = Video.new(vid_params)
        if video.save
          render json: video
        else
          render json: {error: true, message: video.errors}
        end
      end

      # Update queried video
      #
      # POST api/v1/videos/:token/update
      # @see vid_params #vid_params for queried fields
      # @return [VideoSerializer]
      def update
        video = Video.find_by_token(params[:token])
        video.update(vid_params)
        render json: video
      end

      # Archive queried video, set `deleted=true`
      #
      # POST api/v1/videos/:token/archive
      # @return [VideoSerializer]
      # @raise [{error: true, message: video.errors}]
      def archive
        video = Video.find_by_token(params[:token])
        if video.destroy
          render json: {error: false, message: "Archived!"}
        else
          render json: {error: true, message: video.errors}
        end
      end

      # Show path for required video
      #
      # GET api/v1/videos/:token/path
      # @return [{video: id: [Integer], description: [String], token: [String], path: [String], deleted: [Boolean]}]
      # @raise [{error: true, message: video.errors}]
      def path
        video = Video.select(:id, :path, :token, :deleted, :description).find_by_token(params[:token])
        if video.nil?
          video = {error: true, message: "Not Found"}
        end
        render json: video.to_json
      end

      private
      # @!visibility public
      # Strong parameters for quering videos, requires namespace 'video'
      #
      # @param _opts [Hash] Namespace 'video'
      # @option _opts [Integer] :user_id - User id
      # @option _opts [Integer] :key_id - Key id
      # @option _opts [Integer] :game - Game Title
      # @option _opts [Integer] :description - Description
      # @option _opts [Integer] :path - Path to file
      # @option _opts [Integer] :deleted - Archive status
      # @return [Hash]
      def vid_params(_opts={})
        params.require(:video).permit(:user_id, :key_id, :game, :description, :path, :deleted)
      end
    end
  end
end
