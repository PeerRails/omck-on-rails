class StaffController < ApplicationController

  def index

    if current_user
      @tag_ids = []
      @tweets = Tweet.select(:comment, :user_id).order(id: :desc).limit(10)
      @user_key = Key.present.find_by_user_id(current_user.id)
      @channels = Channel.twitch
      @keys_guests = Key.present.is_guest
      @keys_streamers = Key.present.streamers
      @users = User.staff
      @vids = current_user.gmod == 1 ? Video.where(deleted: false) : Video.where(user_id: current_user.id, deleted: false)

      if @user_key.nil?
        @user_key = Key.new(user_id: current_user.id, guest: false, streamer: current_user.name)
      end

      @channel = Channel.new
      @tweet = Tweet.new
      @key = Key.new(guest: true)
      @new_streamer = User.new
    else
      render "login"
    end

  end

  def general

  end

end
