module Api
  module V1
    class KeysController < ApiApplicationController\

      def retrieve
        key = Key.present.where(user_id: current_user.id).last
        render json: key
      end

      def all
        keys = Key.all
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
          render json {error: true, message: key.errors}
        end
      end
    end
  end
end
