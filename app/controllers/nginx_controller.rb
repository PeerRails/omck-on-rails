class NginxController < ApplicationController
  before_filter :check_ip, :only => [:end_cinema, :move_record, :increase_viewer_count, :decrease_viewer_count, :get_key]
  def get_key
    streamer = nil
    streamer = Key.where(key: params_key[:key]).last if params_key[:name]
    list = ReadCache.redis.lrange("live_channel_list", 0, -1)
    if params_key[:name] == "omcktv"
      if streamer.nil?
        render json: error("403"), status: 403
      else
        channel = "hdgames" if (params_key[:app] == "live" and !list.include? "hdgames")
        channel = "hdkinco" if (params_key[:app] == "cinema" and !list.include? "hdkinco")
        ReadCache.redis.rpush "live_channel_list", channel
        update_chan = Channel.where(channel: channel).last
        update_chan.live = true
        update_chan.game = streamer.game if channel == "hdgames"
        update_chan.game = streamer.movie if channel == "hdkinco"
        update_chan.title = streamer.streamer
        update_chan.save
        render json: error("200"), status: 200
      end
    else
        render json: error("403"), status: 403
    end
  end

  def move_record
    if params_key[:key]
      streamer = Key.where(key: params_key[:key]).last
      if params_key[:path]
        list = ReadCache.redis.lrange("live_channel_list", 0, -1)
        ReadCache.redis.lrem "live_channel_list", 0, "hdgames" if (list.include? "hdgames")
        if streamer.nil?
          File.delete(params_key[:path])
        else
          new_file = "/home/prails/Videos/#{streamer.streamer}_-_#{streamer.game.gsub(/\s+/, '_')}_#{DateTime.now.strftime('%Y-%m-%d-%H-%M-%S')}.flv"
          File.rename(params_key[:path], new_file)
        end
      end
      render json: error("200"), status: 200
    else
      render json: error("403"), status: 200
    end
  end

  def end_cinema
    if params_key[:key]
      #streamer = Key.where(key: params[:key]).last
      list = ReadCache.redis.lrange("live_channel_list", 0, -1)
      ReadCache.redis.lrem "live_channel_list", 0, "hdkinco" if (list.include? "hdkinco")
      render json: error("200"), status: 200
    else
      render json: error("403"), status: 200
    end
  end

  def increase_viewer_count
    if params_key[:app]
      channel = "hdgames" if params_key[:app] == "live"
      channel = "hdkinco" if params_key[:app] == "cinema"
      ReadCache.redis.incr "viewers_#{channel}"
    end
    render json: params, status: 200
  end

  def decrease_viewer_count
    if params_key[:app]
      channel = "hdgames" if params_key[:app] == "live"
      channel = "hdkinco" if params_key[:app] == "cinema"
      ReadCache.redis.decr "viewers_#{channel}"
    end
    render json: params, status: 200
  end

  private
  def params_key
  	params.permit(:key, :name, :path)
  end
end