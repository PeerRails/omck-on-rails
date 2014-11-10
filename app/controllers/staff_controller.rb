class StaffController < ApplicationController
  before_filter :check_session

  def index
    session_update
    @tweets = Tweet.select(:comment, :author).order(id: :desc).last(10)
    @user_key = Key.present.find_by_uid(@session["id"])
    @channels = Channel.find_twitch
    @keys = Key.present

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
