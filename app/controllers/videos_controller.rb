class VideosController < ApplicationController

  def remove
    tks = params[:tag_tokens]
    if tks.nil?
      res = {error: true, message: "Invalid tokens", status: 403}
    else
      res = {videos: [], status: 200}
      tks.each do |tk|
        res[:videos].push(delete_by_tk tk)
      end
    end
    render json: res, status: res[:status]
  end

  # yeah
  def delete_by_tk tk
    if tk.nil?
      return {error: true, message: "Required file not found"}
    else
      vid = Video.list.where(token: tk).last
      if vid.nil?
        return {error: true, message: "Required file not found"}
      else
        vid.deleted = true
        if vid.save
          return vid
        else
          return {error: true, message: vid.errors.full_messages}
        end
      end
    end
  end

  def list
    if params[:video].nil?
      res = Video.list
    else
      res = Video.list.where(user_id: vid_params[:user_id])
    end
    render json: res, status: 200
  end

  def vid_params
    params.require(:video).permit(:uid, :user_id)
  end
end
