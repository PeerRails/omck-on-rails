class VideosController < ApplicationController

  def remove
    tks = params[:tag_tokens]
    response = {}
    if tks.nil?
      response = {error: true, message: "Invalid tokens", status: 403}
    else
      tks.each do |tk|
        response.merge(delete_by_tk tk)
      end
    end
    render json: response, status: response[:status]
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
      response = Video.list
    else
      response = Video.list.where(user_id: vid_params[:user_id])
    end
    render json: response, status: 200
  end

  def vid_params
    params.require(:video).permit(:uid, :user_id)
  end
end
