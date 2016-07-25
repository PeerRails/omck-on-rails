class FrontpageController < ApplicationController

  def index
  end

  def player
  	@host = ENV["HD_PLAY"] || "http://localhost:8080"
    @channel = params[:channel]
    render layout: false
  end
end
