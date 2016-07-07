module Api
  module V1
    class StreamsController < ApiApplicationController
      load_and_authorize_resource

      def last
        user = params[:user] || nil
        streams = user.nil? ? Stream.last(10) : Stream.where(user_id: user).last(10)
        render json: streams
      end

      def by_user
        user = params[:user] || nil
        streams = Stream.where(user_id: user)
        render json: streams
      end

      def show
        stream = Stream.find(params[:id])
        render json: stream
      end

      def stop
        stream = Stream.find(params[:id])
        if stream.stop!(DateTime.now)
          render json: stream
        else
          render json: {error: true, message: stream.errors}
        end
      end

      private
      def stream_params
        params.require(:stream).permit(:channel_id, :key_id, :user_id, :game, :streamer)
      end
    end
  end
end
