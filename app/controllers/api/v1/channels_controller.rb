module Api
  module V1
    class ChannelsController < ApiApplicationController
      def live
        channels = Channel.live
        render json: channels
      end

      def all
        channels = Channel.all
        render json: channels
      end

      def show
        channel = Channel.where(service: channel_params[:service], channel: channel_params[:channel])
        render json: channel
      end

      def service
        channels = Channel.where(service: channel_params[:service])
        render json: channels
      end

      def create
        channel = Channel.create(chanmod_params)
        if channel.errors.any?
          render json: {error: true, message: channel.errors}
        else
          render json: channel
        end
      end

      def update
        channel = Channel.where(service: channel_params[:service], channel: channel_params[:channel]).first
        if channel.nil?
          render json: {error: true, message: "Channel not found"}
        else
          channel = Channel.update(channel.id, chanmod_params)
          if channel.errors.any?
            render json: {error: true, message: channel.errors}
          else
            render json: channel
          end
        end
      end

      #search for channel params
      def channel_params
        params.permit(:channel, :service)
      end

      #channel modifying params
      def chanmod_params
        params.require(:channels).permit(:channel, :streamer, :service, :game, :title, :live)
      end
    end
  end
end
