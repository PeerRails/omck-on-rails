class ChannelsController < ApplicationController

  # Get live channels
  def live
    channels = Channel.live
    render json: channels
  end

  # Get all channels
  #
  def all
    channels = Channel.all
    render json: channels
  end

  # Get required channel by service and channel name
  def show
    channel = ChannelOperator.show(show_channel_params)
    status = channel.success? ? 200 : channel.data.status
    render json: channel.data, status: status
  end

  # Post new channel
  #
  def create
    channel = ChannelOperator.create(channel_params)
    status = channel.success? ? 200 : channel.data.status
    render json: channel.data, status: status
  end

  # Put new changes in required channel
  #
  def update
    channel = ChannelOperator.update({channel: params[:channel], service: params[:service], data: data_params})
    status = channel.success? ? 200 : channel.data.status
    render json: channel.data, status: status
  end

  # Delete required channel
  #
  def destroy
    channel = ChannelOperator.destroy({channel: params[:channel], service: params[:service]})
    status = channel.success? ? 200 : channel.data.status
    render json: { message: channel.message, error: channel.error? }, status: status
  end

  # Switch channel's live status
  #
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
