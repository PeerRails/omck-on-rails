class StaffController < ApplicationController
  before_filter :check_session

  def index
    session_update
    @tweets = Tweet.select(:comment, :author).order(id: :desc).last(10)
    @tweet = Tweet.new


  end

  def general

  end

  def guest
    @session = auth

  end


end
