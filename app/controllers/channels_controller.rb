class ChannelsController < ApplicationController
  before_action :check_auth, only: [:remove, :update, :create]

  def list_live
    channels = Channel.live
    render json: channels
  end

  def list_all
    channels = Channel.all.order(:id)
    render json: channels
  end

  def show
    channel = Channel.where(service: channel_params[:service], channel: channel_params[:channel]).first
    unless channel.nil?
      render json: channel
    else
      raise ActiveRecord::RecordNotFound
    end
  end

=begin
  def service_list
    channels = Channel.where(service: chan_params[:service]).map { |ch| serialize ch }
    render json: channels
  end
=end

  def create
    channel = Channel.new(chanmod_params)
    authorize channel unless channel.nil?
    if channel.save
      render json: channel
    else
      render json: {error: true, message: channel.errors}
    end
  end

  def update
    channel = Channel.where(service: channel_params[:service], channel: channel_params[:channel]).first
    authorize channel unless channel.nil?
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

  def remove
    channel = Channel.where(service: channel_params[:service], channel: channel_params[:channel]).first
    authorize channel unless channel.nil?
    if channel.destroy
      render json: {error: nil, message: "Deleted!"}
    else
      render json: {error: true, message: channel.errors}
    end
  end
  # Search for channel params
  def channel_params
    params.permit(:channel, :service)
  end

  # Channel modifying params
  def chanmod_params
    params.require(:channels).permit(:channel, :streamer, :service, :game, :title, :live)
  end

end
