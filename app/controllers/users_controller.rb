class UsersController < ApplicationController
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
      res[:error] = true
      res[:status] = 404
      res[:message] = "User or videos not found"
    else
      res[:videos] = user.videos.list
      res[:status] = 200
    end
    render json: res, status: res[:status]
  end

  #def update
  #end

  def grant
    user = User.where(twitter_id: params[:twitter_id]).last
    res = {}
    if user.nil? || params[:permissions].nil?
      res[:error] = true
      res[:status] = 404
      res[:message] = "User is not found"
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
        res[:error] = true
        res[:status] = 403
        res[:message] = "Invalid permissions"
      end
    end
    render json: res, status: res["status"]
  end
  def perm_params
    params.require(:permissions).permit(:streamer, :gmod)
  end
end
