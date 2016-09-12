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
        if stream.stop!
          render json: stream
        else
          render json: {error: true, message: "It was already stopped"}
        end
      end

      def create
        stream = Stream.new(stream_params)
        if stream.save
          render json: stream
        else
          render json: {error: true, message: stream.errors}
        end
      end

      def delete
        stream = Stream.find(params[:id])
        if stream.destroy
          render json: {error: nil, message: "Deleted!"}
        else
          render json: {error: true, message: stream.errors}
        end
      end

      def by_period
        started = DateTime.parse(date_params[:started])
        ended = DateTime.parse(date_params[:ended])
        streams = Stream.where(ended_at: started..ended)
        render json: streams
      end

      private
      def stream_params
        params.require(:stream).permit(:channel_id, :key_id, :user_id, :game, :streamer, :ended_at)
      end

      def date_params
        params.require(:date).permit(:started, :ended)
      end
    end
  end
end
