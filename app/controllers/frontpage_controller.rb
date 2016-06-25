class FrontpageController < ApplicationController

  def index
  end

  def player
    @channel = params[:channel]
    render layout: false
  end
end
