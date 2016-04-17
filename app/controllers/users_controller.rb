class UsersController < ApplicationController
  before_action :check_auth, only: [:grant, :invite]

  def list
    users = User.all
    render json: users
  end

  def show
    user = User.find(params[:id])
    if user.nil?
      render json: {error: true, message: "User not found"}
    else
      render json: user
    end
  end

  def videos
    user = User.find(params[:id])
    if user.nil?
      render json: {error: true, message: "User or Videos not found"}
    else
      render json: user.videos, each_serializer: VideoSerializer, root: "videos"
    end
  end

  #def update
  #end

  def grant
    user = User.find(params[:id])
    unless user.nil?
      authorize user
      user.update(grant_params)
    end
    if user.save
      render json: user
    else
      render json: {error: true, message: user.errors}
    end
  end

  def invite
    account = tclient.user(user_params[:screen_name], :skip_status => true)
    user = User.find_or_create_by(twitter_id: account.id) do |u|
      u.twitter_id = account.id
      u.screen_name = account.screen_name
      u.name = account.name
    end
    authorize user
    if user.update(streamer: 1)
      render json: user
    else
      render json: {error: true, message: user.errors}
    end
  end

  def user_params
    params.require(:user).permit(:screen_name, :name, :profile_image_url)
  end

  def grant_params
    params.require(:user).permit(:streamer, :gmod)
  end

end
