class StaffController < ApplicationController
  before_filter :check_session

  def index
    @tweets = Tweet.select(:comment, :user_id).order(id: :desc).limit(10)
    @user_key = Key.present.find_by_user_id(current_user.id)
    @channels = Channel.find_twitch
    @keys_guests = Key.present.guests
    @keys_streamers = Key.present.streamers
    @users = User.staff

    if @user_key.nil?
      @user_key = Key.new(user_id: current_user.id, guest: false, streamer: current_user.name)
    end

    @channel = Channel.new
    @tweet = Tweet.new
    @key = Key.new(guest: true)
    @new_streamer = User.new

  end

  def general

  end

end
