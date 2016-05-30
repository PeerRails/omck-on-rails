module Api
  module V1
    class VideosController < ApiApplicationController
      load_and_authorize_resource

      def list
        deleted = params[:deleted] == "true" ? true : false
        videos = Video.where(deleted: deleted)
        render json: videos
      end

      def show
        video = Video.find_by_token(params[:token])
        render json: video
      end

      def add
        video = Video.new(vid_params)
        if video.save
          render json: video
        else
          render json: {error: true, message: video.errors}
        end
      end

      def update
        video = Video.find_by_token(params[:token])
        video.update(vid_params)
        render json: video
      end

      def archive
        video = Video.find_by_token(params[:token])
        if video.destroy
          render json: {error: false, message: "Archived!"}
        else
          render json: {error: true, message: video.errors}
        end
      end

      def vid_params
        params.require(:video).permit(:user_id, :key_id, :game, :description, :path, :deleted)
      end
    end
  end
end
