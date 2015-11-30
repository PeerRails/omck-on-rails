class ChannelsController < ApplicationController
  #before_filter :auth, except: [:bitdash]

  def list_live
    channels = Channel.live.map { |ch| serialize ch }
    render json: channels.to_json
  end

  def list_all
    channels = Channel.all.map { |ch| serialize ch}
    render json: channels.to_json
  end

  def show
    channel = Channel.where(service: chan_params[:service], channel: chan_params[:channel]).last
    unless channel.nil?
      render json: (serialize channel)
    else
      render json: {error: true, message: "Not Found"}, status: 404
    end
  end

  def list_service_channels
    channels = Channel.where(service: chan_params[:service]).map { |ch| serialize ch }
    render json: channels
  end

  def new
    unless chan_params.nil? || chan_params[:service].nil? || chan_params[:channel].nil?
      unless Channel.where(service: chan_params[:service], channel: chan_params[:channel]).last.nil?
        response = {error: true, message: "Channel exists already"}
        response_status = 403
      else
        channel = Channel.new(service: chan_params[:service], channel: chan_params[:channel], streamer: chan_params[:streamer])
        if channel.save
          response = serialize channel
          response_status = 200
        else
          response = {error: 403, message: "Something went wrong"}
          response_status = 403
        end
      end
    else
      response = {error: true, message: "No valid params"}
      response_status = 403
    end
    render json: response, status: response_status
  end

  def update
    channel = Channel.where(service: chan_params[:service], channel: chan_params[:channel]).last
    if channel.nil?
      response = {error: true, message: "Channel not found"}
    else
      channel.title = chan_params[:title] unless chan_params[:title].nil?
      channel.game = chan_params[:game] unless chan_params[:game].nil?
      channel.streamer = chan_params[:streamer] unless chan_params[:streamer].nil?
      if channel.save
        response = serialize channel
      else
        response = {error: true, message: "Invalid data"}
        response_status = 500
      end
      render json: response, status: response_status
    end
  end

  def chan_params
    params.permit(:channel, :streamer, :service, :game, :title)
  end

  private
  def serialize chan
    return {"channel" => chan.channel,
            "viewers" => chan.viewers,
            "live" => chan.live,
            "game" => chan.game,
            "title" => chan.title,
            "streamer" => chan.streamer,
            "service" => chan.service,
            "error" => nil}

  end

end
