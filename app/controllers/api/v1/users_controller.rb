module Api
  module V1
    class UsersController < ApiApplicationController

      def list
        users = User.all
        render json: users
      end

      def show
        user = User.find(params[:id])
        if user.nil?
          render json: {error: true, message: "User not found"}
        else
          render json: user
        end
      end

      def videos
        user = User.find(params[:id])
        if user.nil?
          render json: {error: true, message: "User or Videos not found"}
        else
          render json: user.videos, each_serializer: VideoSerializer, root: "videos"
        end
      end

      def update
        user = User.find(params[:id])
        user.update(user_params)
        if user.save
          render json: user
        else
          render json: {error: true, message: user.errors}
        end
      end

      def grant
        user = User.find(params[:id])
        user.update(grant_params)
        if user.save
          render json: user
        else
          render json: {error: true, message: user.errors}
        end
      end

      def user_params
        params.require(:user).permit(:screen_name, :name, :profile_image_url)
      end

      def grant_params
        params.require(:user).permit(:streamer, :gmod)
      end
    end
  end
end
