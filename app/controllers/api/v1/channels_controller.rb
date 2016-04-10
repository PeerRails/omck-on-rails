module Api
  module V1
    class ChannelsController < ApiApplicationController
      #include CanCan::ControllerAdditions
      #load_and_authorize_resource

      # List live channels at current moment
      # Request:
      # GET /api/v1/channels/live.json
      # Response:
      # {"channels":
      #   [{"channel": string,
      #     "viewers": integer,
      #     "live": boolean,
      #     "game": string,
      #     "title": string,
      #     "streamer": string,
      #     "service": string ("hd" or "twitch"),
      #     "official": boolean,
      #     "url": string},
      #    ...
      #  ]
      # }
      def live
        channels = Channel.live
        render json: channels
      end

      # List all channels
      # Request:
      # GET /api/v1/channels/all.json
      # Response:
      # {"channels":
      #   [{"channel": string,
      #     "viewers": integer,
      #     "live": boolean,
      #     "game": string,
      #     "title": string,
      #     "streamer": string,
      #     "service": string ("hd" or "twitch"),
      #     "official": boolean,
      #     "url": string},
      #    ...
      #  ]
      # }
      def all
        channels = Channel.all
        render json: channels
      end

      # Show required channel
      # Request:
      # GET /api/v1/channels/twitch/kraken
      # Response:
      # {"channels":
      #   [{"channel": string,
      #     "viewers": integer,
      #     "live": boolean,
      #     "game": string,
      #     "title": string,
      #     "streamer": string,
      #     "service": string ("hd" or "twitch"),
      #     "official": boolean,
      #     "url": string}
      #  ]
      # }
      def show
        channel = Channel.where(service: channel_params[:service], channel: channel_params[:channel])
        render json: channel
      end

      # Show all channels from required service
      # Request:
      # GET /api/v1/channels/twitch
      # Response:
      # {"channels":
      #   [{"channel": string,
      #     "viewers": integer,
      #     "live": boolean,
      #     "game": string,
      #     "title": string,
      #     "streamer": string,
      #     "service": string ("hd" or "twitch"),
      #     "official": boolean,
      #     "url": string},
      #     ...
      #  ]
      # }
      def service
        channels = Channel.where(service: channel_params[:service])
        render json: channels
      end

      # Create channel
      # Request:
      # POST /api/v1/channels/create.json
      # Body:
      # {"channels": {
      #    "service": "twitch"(required),
      #    "channel": string(required),
      #    "streamer": string(required),
      #    "game": string,
      #    "title": string,
      #    "live": string
      #  }
      # }
      # Response:
      # {"channels":
      #   [{"channel": string,
      #     "viewers": integer,
      #     "live": boolean,
      #     "game": string,
      #     "title": string,
      #     "streamer": string,
      #     "service": string,
      #     "official": boolean,
      #     "url": string},
      #     ...
      #  ]
      # }
      def create
        channel = Channel.create(chanmod_params)
        if channel.errors.any?
          render json: {error: true, message: channel.errors}
        else
          render json: channel
        end
      end

      # Update channel
      # Request:
      # POST /api/v1/channels/twitch/kraken/update.json
      # Body:
      # {"channels": {
      #    "game": string,
      #    "title": string,
      #    "live": string
      #  }
      # }
      # Response:
      # {"channels":
      #   [{"channel": string,
      #     "viewers": integer,
      #     "live": boolean,
      #     "game": string,
      #     "title": string,
      #     "streamer": string,
      #     "service": string,
      #     "official": boolean,
      #     "url": string},
      #     ...
      #  ]
      # }
      def update
        channel = Channel.where(service: channel_params[:service], channel: channel_params[:channel]).first
        if channel.nil?
          render json: {error: true, message: "Channel not found"}
        else
          channel = Channel.update(channel.id, chanmod_params)
          if channel.errors.any?
            render json: {error: true, message: channel.errors}
          else
            render json: channel
          end
        end
      end

      # Delete channel
      # Request:
      # DELETE /api/v1/channels/twitch/kraken/delete.json
      # Response:
      # {
      #  "error": null,
      #  "message": string
      # }
      def delete
        channel = Channel.where(service: channel_params[:service], channel: channel_params[:channel]).first
        if channel.destroy
          render json: {error: nil, message: "Deleted!"}
        else
          render json: {error: true, message: channel.errors}
        end
      end

      # Search for channel params
      def channel_params
        params.permit(:channel, :service)
      end

      # Channel modifying params
      def chanmod_params
        params.require(:channels).permit(:channel, :streamer, :service, :game, :title, :live)
      end
    end
  end
end
