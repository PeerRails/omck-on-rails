class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    if params && params[:twitter_id]
      res = {}
      user = User.where(twitter_id: params[:twitter_id]).last
      if user.nil?
        res = {error: true, message: "User not found", status: 404}
      else
        res = user.to_json
      end
    else
      res = {error: true, message: "Invalid input data", status: 403}
    end
    render json: res, status: res["status"]
  end

  def videos
    user = User.where(twitter_id: params[:twitter_id]).last
    res = {}
    if user.nil? || user.videos.list.empty?
      res = {error: true, message: "User or videos not found", status: 404}
    else
      res = {videos: user.videos.list, status: 200, error: nil}
    end
    render json: res, status: res[:status]
  end

  #def update
  #end

  def grant
    user = User.where(twitter_id: params[:twitter_id]).last
    res = {}
    if user.nil? || params[:permissions].nil?
      res = {error: true, message: "User is not found", status: 404}
    else
      user.streamer = perm_params[:streamer] if perm_params[:streamer]
      user.gmod = perm_params[:gmod] if perm_params[:gmod]
      if user.save
        res = user.to_json
        if user.keys.present.empty?
          key = Key.new(user_id: user.id, key: SecureRandom.uuid, streamer: user.name, expires: DateTime.now + 900)
          key.save
        end
      else
        res = {error: true, message: user.errors.full_messages, status: 500}
      end
    end
    render json: res, status: res["status"]
  end

  def perm_params
    params.require(:permissions).permit(:streamer, :gmod)
  end

  def serialize user
    return {
      twitter_id: user.twitter_id,
      name: user.name,
      screen_name: user.screen_name,
      streamer: user.streamer,
      gmod: user.gmod
    }
  end
end
