class ChannelsController < ApplicationController
  before_filter :auth, except: [:bitdash]


  def new
    chan = chan_params
    if current_user.streamer == 1 || current_user.gmod == 1
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
  if current_user.gmod == 1 || current_user.streamer == 1
    channel = chan_params
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
  if current_user.gmod == 1 || current_user.streamer == 1
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

def bitdash
  channel = params.require(:channel) || "records"
  fmt = params[:fmt] || "default"
  unless ["default", "rtmp", "hls", "dash"].include? fmt
    @fmt = "default"
  else
    @fmt = fmt
  end
  if request.host == "localhost"
    @host = "127.0.0.1"
  else
    @host = "hd." + request.host
  end

  case channel
  when "hdgames"
    @channel = "live"
  when "hdkinco"
    @channel = "cinema"
  when "records"
    @channel = "records"
  end
  if @channel.nil?
    redirect_to '/bitdash/records'
  else
    render layout: false
  end
end

def chan_params
  params.require(:channel).permit(:channel, :streamer)
end

end
