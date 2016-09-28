module Api
  module V1
    # API Channel Controller
    # Class for handling channel requests
    #
    # @todo Add pagination
    class ChannelsController < ApiApplicationController
      load_and_authorize_resource


      # Return list of channels that live at current moment
      #
      # GET /api/v1/channels/live
      # @return [Array<ChannelSerializer>]
      def live
        channels = Channel.live
        render json: channels
      end


      # Return list of all channels
      #
      # GET /api/v1/channels/live
      # @return [Array<ChannelSerializer>]
      def all
        channels = Channel.all.order(:id)
        render json: channels
      end


      # Show required channel
      #
      # GET /api/v1/channels/:service/:channel
      # @return [ChannelSerializer]
      # @raise [ActiveRecord::RecordNotFound]
      def show
        channel = Channel.where(service: channel_params[:service], channel: channel_params[:channel]).first
        render json: channel
      end


      # Show all channels with required service
      #
      # GET /api/v1/channels/:service
      # @return [Array<ChannelSerializer>]
      def service
        channels = Channel.where(service: channel_params[:service])
        render json: channels
      end


      # Create channel
      #
      # @see channel_params #channel_params for query fields
      # @see chanmod_params #chanmod_params for editing fields
      # POST /api/v1/channels/create
      # @return [ChannelSerializer]
      def create
        channel = Channel.new(chanmod_params)
        if channel.save
          render json: channel
        else
          render json: {error: true, message: channel.errors}
        end
      end


      # Update channel
      #
      # POST /api/v1/channels/:service/:channel/update
      # @see channel_params #channel_params for query fields
      # @see chanmod_params #chanmod_params for editing fields
      # @return [ChannelSerializer]
      def update
        channel = Channel.where(service: channel_params[:service], channel: channel_params[:channel]).first
        if channel.nil?
          render json: {error: true, message: "Channel not found"}
        else
          if channel.update(chanmod_params)
            render json: channel
          else
            render json: {error: true, message: channel.errors}
          end
        end
      end


      # Delete channel
      #
      # DELETE /api/v1/channels/:service/:channel/delete
      # @example Example response
      #    {error: true|nil, message: "Deleted!"|[Error]}
      # @return [JSON]
      def delete
        channel = Channel.where(service: channel_params[:service], channel: channel_params[:channel]).first
        if channel.destroy
          render json: {error: nil, message: "Deleted!"}
        else
          render json: {error: true, message: channel.errors}
        end
      end


      private
      # @!visibility public
      # Strong parameters for querying channel
      # @param _opts [Hash]
      # @option _opts [String] :service Livestream Service
      # @option _opts [String] :channel Channel Name
      # @return [Hash]
      def channel_params(_opts={})
        params.permit(:channel, :service)
      end


      # @!visibility public
      # Strong parameters for editing channel, requires namespace 'channels'
      #
      # @param _opts [Hash] Namespace 'channels'
      # @option _opts [String] :service Livestream Service
      # @option _opts [String] :channel Channel Name
      # @option _opts [String] :game - *optional* game title
      # @option _opts [String] :streamer - *optional* streamer name
      # @option _opts [Boolean] :live - *optional* Live Status
      # @option _opts [Integer] :viewers - *optional* viewer count
      # @option _opts [String] :title - *optional* Channel title
      # @return [Hash]
      def chanmod_params(_opts={})
        params.require(:channels).permit(:channel, :streamer, :service, :game, :title, :live, :viewers)
      end


    end
  end
end
