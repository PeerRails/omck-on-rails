class StaffController < ApplicationController
  before_filter :check_session

  def index
    session_update
    @tweets = Tweet.select(:comment, :author).order(id: :desc).limit(10)
    @user_key = Key.present.find_by_uid(@session["id"])
    @channels = Channel.find_twitch
    @keys_guests = Key.present.guests
    @keys_streamers = Key.present.streamers

    if @user_key.nil?
      @user_key = Key.new(uid: @session["id"], guest: false, streamer: @session["name"])
    end
    @channel = Channel.new
    @tweet = Tweet.new
    @key = Key.new(guest: true)
    @new_streamer = User.new

  end

  def general

  end

  def guest
    @session = auth

  end


end
