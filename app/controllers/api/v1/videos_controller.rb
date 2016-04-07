module Api
  module V1
    class VideosController < ApiApplicationController

      def list
        videos = Video.where(deleted: false)
        render json: videos
      end

      def vid_params
        params.require(:video).permit(:user_id, :key_id, :game, :description, :token, :path, :deleted)
      end
    end
  end
end
