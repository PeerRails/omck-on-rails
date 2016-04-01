module Api
  module V1
    class KeysController < ApiApplicationController

      def retrieve
        key = Key.present.where(user_id: current_user.id).last
        render json: key
      end

      def all
        keys = Key.present
        render json: keys
      end

      def guest
        keys = Key.is_guest
        render json: keys
      end

      def create
        key = Key.new(key_params)
        if key.save
          render json: key
        else
          render json: { error: true, message: key.errors }
        end
      end

      def regenerate
        key = User.find(key_params[:user_id]).keys.present.last
        if key.expire
          new_key = Key.create(user_id: key.user_id, guest: false, streamer: key.streamer, game: key.game, movie: key.movie, created_by: current_user.id)
          render json: new_key
        else
          render json: { error: true, message: key.errors }
        end
      end

      def update
        key = User.find(key_params[:user_id]).keys.present.last
        key.update(key_params_update)
        if key.save
          render json: key
        else
          render json: { error: true, message: key.errors }
        end
      end

      def expire
        key = User.find(key_params[:user_id]).keys.present.last
        if key.expire
          render json: { error: nil, message: "Ключ испарен!" }
        else
          render json: { error: true, message: key.errors }
        end
      end

      def key_params
        params.require(:key).permit(:user_id, :guest, :streamer, :game, :movie)
      end

      def key_params_update
        params.require(:key).permit(:streamer, :game, :movie)
      end
    end
  end
end
