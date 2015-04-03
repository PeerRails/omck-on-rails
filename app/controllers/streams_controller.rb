class StreamsController < ApplicationController

  def get_live
    lives = []
    Channel.live.each do |channel|
      lives << channel_info(channel)
    end

    if !lives.empty?
	  render json: lives
    else
      render json: []
    end
  end

  def get_all
    channels = []
    Channel.all.each do |channel|
      channels << channel_info(channel)
    end
    render json: channels
  end

  def get_channel
    channel = channel_info Channel.select(:channel, :streamer, :game, :live, :viewers, :title, :service)
                     .where(:channel => params_channel[:channel])
                     .last
    if channel.nil?
      render json: error("404")
    else
      render json: channel
    end
  end

  private
  def params_channel
  	params.permit(:channel, :service)
  end

  private
  def channel_info chan
    return {"channel" => chan.channel,
        "viewers" => chan.viewers,
        "live" => chan.live,
        "game" => chan.game,
        "title" => chan.title,
        "streamer" => chan.streamer,
        "service" => chan.service}

  end

end
