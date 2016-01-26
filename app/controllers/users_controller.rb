class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    if params && params[:twitter_id]
      res = {}
      user = User.where(twitter_id: params[:twitter_id]).last
      if user.nil?
        res = {error: true, message: "User not found", status: 404}
      else
        res = (serialize user).to_json
      end
    else
      res = {error: true, message: "Invalid input data", status: 403}
    end
    render json: res, status: res["status"]
  end

  def list
    res = User.all.order(:id).map { |u| serialize u }
    render json: res, status: 200
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
    elsif user.id == current_user.id
      res = {error: true, message: "You cannot grant access to yourself", status: 403}
    else
      user.streamer = perm_params[:streamer] if perm_params[:streamer]
      user.gmod = perm_params[:gmod] if perm_params[:gmod]
      if user.save
        res = user.to_json
      else
        res = {error: true, message: user.errors.full_messages, status: 500}
      end
    end
    render json: res, status: res["status"]
  end

  def invite
    invitee = invite_params[:screen_name]
    user = User.where(screen_name: invitee).last
    if user.nil?
      account = tclient.user(invitee, :skip_status => true)
      user = User.new(twitter_id: account.id, screen_name: account.screen_name, name: account.name, streamer: 1)
      if user.save
        res = serialize user
      else
        res = {error: true, message: user.errors.full_messages, status: 503}
      end
    elsif user.id == current_user.id
      res = {error: true, message: "You cannot grant access to yourself", status: 200, twitter_id: current_user.screen_name, another: invitee}
    elsif user.streamer == 0
      user = User.update(user.id, streamer: 1)
      res = serialize user
    else
      res = {error: true, message: "User exists and has permission to stream", status: 200}
    end
    render json: res
  end

  def perm_params
    params.require(:permissions).permit(:streamer, :gmod)
  end

  def invite_params
    params.permit(:screen_name)
  end

  def serialize user
    return {
      twitter_id: user.twitter_id,
      name: user.name,
      screen_name: user.screen_name,
      profile_image_url: user.profile_image_url,
      streamer: (user.streamer == 1 ? true : false),
      gmod: (user.gmod == 1 ? true : false)
    }
  end
end
