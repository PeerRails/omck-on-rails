class ChannelsController < ApplicationController

  # Get live channels
  #
  # @return [Array]
  def live
    channels = Channel.live
    render json: channels
  end

  # Get all channels
  #
  # @return [Array]
  def all
    channels = Channel.all
    render json: channels
  end

  # Get required channel by service and channel name
  #
  # @param service [String]
  # @param channel [String]
  # @return [Channel]
  def show
    channel = ChannelOperator.show(show_channel_params)
    status = channel.success? ? 200 : channel.data.status
    render json: channel.data, status: status
  end

  # Post new channel
  #
  # @param [Hash] channel_params (see #channel_params)
  # @option channel_params [String] :channel Channel name
  # @option channel_params [String] :service Service name
  # @option channel_params [String] :streamer Streamer name
  # @option channel_params [Boolean] :live Status of channel
  # @option channel_params [Integer] :viewers Viewer count
  # @return [Response]
  def create
    channel = ChannelOperator.create(channel_params)
    status = channel.success? ? 200 : channel.data.status
    render json: channel.data, status: status
    #render json: { error: channel.error?, response: channel.data }
  end

  # Put new changes in required channel
  #
  # @param channel [String]
  # @param service [String]
  # @param [Hash] data (see #channel_params)
  # @option channel_params [String] :channel Channel name
  # @option channel_params [String] :service Service name
  # @option channel_params [String] :streamer Streamer name
  # @option channel_params [Integer] :viewers Viewer count
  # @option channel_params [Boolean] :live Status of channel
  # @return [Response]
  def update
    channel = ChannelOperator.update({channel: params[:channel], service: params[:service], data: data_params})
    status = channel.success? ? 200 : channel.data.status
    render json: channel.data, status: status
  end

  # Delete required channel
  #
  # @param channel [String]
  # @param service [String]
  # @return [Hash]
  def destroy
    channel = ChannelOperator.destroy({channel: params[:channel], service: params[:service]})
    status = channel.success? ? 200 : channel.data.status
    render json: { message: channel.message, error: channel.error? }, status: status
  end

  # Switch channel's live status
  #
  # @param channel [String]
  # @param service [String]
  # @return [Channel]
  def switch
    channel = ChannelOperator.switch({ service: params[:service], channel: params[:channel] })
    status = channel.success? ? 200 : channel.data.status
    render json: channel.data, status: status
  end

  private
    def channel_params
      params.require(:channel).permit(:channel, :service, :streamer)
    end

    def data_params
      params.require(:data).permit(:live, :viewers)
    end

    def show_channel_params
      params.permit(:channel, :service)
    end
end
