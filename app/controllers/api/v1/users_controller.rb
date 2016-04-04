module Api
  module V1
    class UsersController < ApiApplicationController

      def list
        users = User.all
        render json: users
      end

      def show
        user = User.find_by_twitter_id(params[:twitter_id])
        if user.nil?
          render json: {error: true, message: "User not found"}
        else
          render json: user
        end
      end

    end
  end
end
