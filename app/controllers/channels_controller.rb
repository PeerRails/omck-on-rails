class ChannelsController < ApplicationController
  before_filter :auth, except: [:bitdash]

def list_live

end

def list_all

end

def show

end

def list_service_channels

end

def new

end

def update

end

def chan_params
  params.require(:channel).permit(:channel, :streamer)
end

end
