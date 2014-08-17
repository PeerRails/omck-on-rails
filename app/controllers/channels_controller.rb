class ChannelsController < ApplicationController
  before_filter :check_session, :only => [:new, :edit, :delete]
  before_filter :check_ip, :only => [:end_cinema, :move_record, :increase_viewer_count, :decrease_viewer_count, :get_key]
  def get_live
		live = ReadCache.redis.lrange("live_channel_list", 0, -1)
		lives = []
		live.each do |s|
			viewers = ReadCache.redis.get("viewers_#{s}")
      channel_info = Channel.where(:channel => s).last
      if !channel_info.nil?
  			lives << {"channel" => s,
          "viewers" => viewers,
          "status" => "live",
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
    channels = Channel.all
    render json: channels.to_json
  end

  def get_channel
    channel = Channel.where(:channel => params[:channel]).last
    if channel.nil?
      render json: error("403")
    else
      render json: channel.to_json
    end
  end

  def get_key
    streamer = nil
    streamer = Key.where(key: params[:key]).last if params[:key]
    list = ReadCache.redis.lrange("live_channel_list", 0, -1)
    if params[:name] == "omcktv"
      if streamer.nil?
        render json: error("403"), status: 403
      else
        render json: error("200"), status: 200
        channel = "hdgames" if (params[:app] == "live" and !list.include? "hdgames")
        channel = "hdkinco" if (params[:app] == "cinema" and !list.include? "hdkinco")
        ReadCache.redis.rpush "live_channel_list", channel
        update_chan = Channel.where(channel: channel).last
        update_chan.live = true
        update_chan.game = streamer.game if channel == "hdgames"
        update_chan.game = streamer.movie if channel == "hdkinco"
        update_chan.title = streamer.streamer
        update_chan.save
      end
    else
        render json: error("403"), status: 403
    end
  end

  def move_record
    if params[:key]
      streamer = Key.where(key: params[:key]).last
      if params[:path]
        if streamer.nil?
          File.delete(params[:path])
        else
          new_file = "/home/prails/Videos/#{streamer.streamer}_-_#{streamer.game.gsub(/\s+/, '_')}_#{DateTime.now.strftime('%Y-%m-%d-%H-%M-%S')}.flv"
          File.rename(params[:path], new_file)
        end
        list = ReadCache.redis.lrange("live_channel_list", 0, -1)
        ReadCache.redis.lrem "live_channel_list", 0, "hdgames" if (list.include? "hdgames")
      end
      render json: error("200"), status: 200
    else
      render json: error("403"), status: 200
    end
  end

  def end_cinema
    if params[:key]
      streamer = Key.where(key: params[:key]).last
        list = ReadCache.redis.lrange("live_channel_list", 0, -1)
        ReadCache.redis.lrem "live_channel_list", 0, "hdkinco" if (list.include? "hdkinco")
      render json: error("200"), status: 200
    else
      render json: error("403"), status: 200
    end
  end

  def increase_viewer_count
    if params[:app]
      channel = "hdgames" if params[:app] == "live"
      channel = "hdkinco" if params[:app] == "cinema"
      ReadCache.redis.incr "viewers_#{channel}"
    end
    render json: params, status: 200
  end

  def decrease_viewer_count
    if params[:app]
      channel = "hdgames" if params[:app] == "live"
      channel = "hdkinco" if params[:app] == "cinema"
      ReadCache.redis.decr "viewers_#{channel}"
    end
    render json: params, status: 200
  end

  def new
    chan = params.require(:channel).permit(:channel, :streamer)
    if @session["gmod"] == "1"
      @channel = Channel.new(channel: chan["channel"], streamer: chan["streamer"])
      if @channel.save
        flash[:success] = "Канал #{@channel.channel} добавлен!"
      else
        flash[:danger] = "Произошла ошибка!"
      end
    else
      flash[:danger] = "Для создания канала нужны права модера!"
    end
    redirect_to home_url
  end
def edit
  if @session["gmod"] == "1"
    channel = params.require(:channel).permit(:channel, :streamer)
    @channel = Channel.where(channel: channel["channel"] ).last
    @channel.streamer = @channel["streamer"]
    if @channel.save
      flash[:success] = "Канал #{@channel.channel} обновлен!"
    else
      flash[:danger] = "Произошла ошибка!"
    end
    redirect_to home_url
  else
    flash[:danger] = "Для редактирования канала нужны права модера!"
    redirect_to root_url
  end
end

def delete
  if @session["gmod"] == "1"
    channel = params.permit(:id)
    @channel = Channel.find(channel["id"])
    if @channel.delete
      flash[:success] = "Канал #{@channel.channel} удален!"
    else
      flash[:danger] = "Произошла ошибка!"
    end
    redirect_to home_url
  else
    flash[:danger] = "Для удаления канала нужны права модера!"
    redirect_to root_url
  end
end

end
