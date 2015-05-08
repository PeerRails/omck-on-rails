class StreamsController < ApplicationController

  def get_live
    lives = []
    Channel.live.each do |channel|
      lives << serialize(channel)
    end

    if !lives.empty?
	  render json: lives
    else
      render json: []
    end
  end

  def get_channel
    channel = serialize Channel.select(:channel, :streamer, :game, :live, :viewers, :title, :service)
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
  def serialize chan
    return {"channel" => chan.channel,
        "viewers" => chan.viewers,
        "live" => chan.live,
        "game" => chan.game,
        "title" => chan.title,
        "streamer" => chan.streamer,
        "service" => chan.service}

  end

end
