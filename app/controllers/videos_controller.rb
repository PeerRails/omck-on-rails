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
    if vid.nil?
      flash[:danger] = "Такого видео нет!"
    else
      flash[:success] = "Удалено!"
      File.re
    end
    redirect_to home_path
  end

  def download
    vid = Video.find(vid_params[:id])
    if vid.nil?
      flash[:danger] = "Такого файла нет!"
      redirect_to home_path
    else
      send_file(vid.path, :filename => "#{vid.created_at.strftime("%D")} #{vid.description}.flv")
    end
  end

  def list
    vids = Video.select("game, description, deleted").where(user_id: vid_params[:user_id])
    render json: vids
  end

  def vid_params
    params.permit(:id, :user_id)
  end
end
