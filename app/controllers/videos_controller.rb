class VideosController < ApplicationController
  before_action :auth

  # not now
  def upload
  end

  #not now
  def move
  end

  def check_deleted
    count = 0
    Video.where(deleted: false).each do |v|
      replay = Playlist.where(id: v.id).last
      unless File.exist?(v.path)
        v.deleted = true
        v.save
        count += 1
        unless replay.nil?
          replay.destroy
        end
      end
    end
    flash[:success] = "Проверка выполнена, удалено #{count}"
    redirect_to home_url
  end

  def delete
    ids = params[:tag_ids]
    if ids.nil?
      flash[:danger] = "Ничего не выбрано."
    else
      ids.each do |id|
        delete_by_id id
      end
    end
    flash[:success] = "Сделано"
    redirect_to home_url
  end

  # yeah
  def delete_by_id id
    vid = Video.find(id)
    replay = Playlist.where(id: id).last
    if vid.nil?
      flash[:danger] = "Такого видео нет!"
    else
      if current_user.gmod ==1 || current_user.id == vid.user_id
        if !replay.nil? && replay.status == 2
          replay.status = 5
          replay.save
        else
          if !replay.nil?
            replay.destroy
          end
          File.delete(vid.path.to_s)
        end
        vid.deleted = true
        vid.save
      else
        flash[:success] = "Вы не владелец данного видео!"
      end
    end
  end

  def list
    vids = Video.select("game, description, deleted").where(user_id: vid_params[:user_id])
    render json: vids
  end

  def vid_params
    params.require(:video).permit(:id, :user_id)
  end
end
