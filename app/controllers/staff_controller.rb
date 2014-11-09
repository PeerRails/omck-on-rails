class StaffController < ApplicationController
  before_filter :check_session

  def index
    session_update
    @tweets = Tweet.select(:comment, :author).order(id: :desc).last(10)
    @user_key = Key.find_by_uid(@session["id"])
    @channels = Channel.select(:streamer, :service, :channel, :game, :live).where(service: "twitch")
    @keys = Key.select(:streamer, :game, :movie, :expires).present

    if @user_key.nil?
      @user_key = Key.new(uid: @session["id"], guest: false, streamer: @session["name"])
    end
    @channel = Channel.new
    @tweet = Tweet.new


  end

  def general

  end

  def guest
    @session = auth

  end


end
