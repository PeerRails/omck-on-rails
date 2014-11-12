class StreamsController < ApplicationController

  def get_live
	live = ReadCache.redis.lrange("live_channel_list", 0, -1)
	lives = []
	live.each do |s|
	  viewers = ReadCache.redis.get("viewers_#{s}")
    channel_info = Channel.where(:channel => s).last
    if !channel_info.nil?
  	  lives << {"channel" => s,
          "viewers" => viewers,
          "live" => channel_info.live,
          "game" => channel_info.game,
          "title" => channel_info.title,
          "streamer" => channel_info.streamer,
          "service" => channel_info.service}
      end
		end
    if !lives.empty?
	  render json: lives.to_json
    else
      render json: error("nostream")
    end
  end

  def get_all
    channels = Channel.select(:channel, :streamer, :game, :live, :viewers, :title, :service).all
    render json: channels.to_json
  end

  def get_channel
    channel = Channel.select(:channel, :streamer, :game, :live, :viewers, :title, :service)
                     .where(:channel => params_channel[:channel])
                     .last
    if channel.nil?
      render json: error("404")
    else
      render json: channel.to_json
    end
  end

  private
  def params_channel
  	params.permit(:channel)
  end

end
