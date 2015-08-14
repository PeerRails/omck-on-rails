class VideosController < ApplicationController
  before_action :auth

  # not now
  def upload
  end

  #not now
  def move
  end

  # yeah
  def delete
    vid = Video.find(vid_params[:id])
    replay = Playlist.find_by_video_id(vid_params[:id])
    if vid.nil?
      flash[:danger] = "Такого видео нет!"
    else
      if current_user.gmod ==1 || current_user.id == vid.user_id
        if !replay.nil? && replay.status == 2
          replay.status = 5
          replay.save
        else
          File.delete(vid.path)
          replay.destroy
        end
        vid.deleted = true
        vid.save
        flash[:success] = "Удалено!"
      else
        flash[:success] = "Вы не владелец данного видео!"
      end
      
    end
    redirect_to home_path
  end

  def list
    vids = Video.select("game, description, deleted").where(user_id: vid_params[:user_id])
    render json: vids
  end

  def vid_params
    params.permit(:id, :user_id)
  end
end
