class ChannelsController < ApplicationController
  before_filter :auth, :only => [:new, :edit, :delete]


  def new
    chan = params.require(:channel).permit(:channel, :streamer)
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

end
