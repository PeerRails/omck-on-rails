class StaffController < ApplicationController
  before_filter :check_session

  def index
    session_update
    @tweets = Tweet.select(:comment, :author).order(id: :desc).last(10)
    @tweet = Tweet.new
    @user_key = Key.find_by_uid(@session["id"])
    if @user_key.nil?
      @user_key = Key.new(uid: @session["id"], guest: false, streamer: @session["name"])
    end


  end

  def general

  end

  def guest
    @session = auth

  end


end
