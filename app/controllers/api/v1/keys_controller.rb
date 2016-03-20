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
    end
  end
end
