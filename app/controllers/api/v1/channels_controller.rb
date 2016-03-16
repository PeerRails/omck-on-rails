class ChannelsApiController < ApiApplicationController
  def live
    channels = Channel.live
    render json: channels
  end
end
