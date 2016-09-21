module Api
  module V1

    # API Stream Controller
    # Class for handling stream requests
    class StreamsController < ApiApplicationController
      load_and_authorize_resource

      # Returns last 10 streams
      #
      # GET api/v1/streams/last
      # GET api/v1/streams/:user/last
      # @note Optional parameter *user* [Integer] _id user_
      # @return [StreamSerializer]
      # @todo add pagination
      def last
        user = params[:user] || nil
        streams = user.nil? ? Stream.last(10) : Stream.where(user_id: user).last(10)
        render json: streams
      end

      # Returns all stream of required or current user
      #
      # @note Optional parameter *user* [Integer] _id user_
      # GET api/v1/streams/:user/list
      # @return [StreamSerializer]
      # @todo add pagination
      def by_user
        user = params[:user] || nil
        streams = Stream.where(user_id: user)
        render json: streams
      end

      # Returns required stream
      #
      # GET api/v1/streams/:id/show
      # @return [StreamSerializer]
      def show
        stream = Stream.find(params[:id])
        render json: stream
      end

      # Updated *ended_at* field with current time
      #
      # GET api/v1/streams/:id/stop
      # @return [StreamSerializer]
      # @raise [{error: true, message: "It was already stopped"}]
      def stop
        stream = Stream.find(params[:id])
        if stream.stop!
          render json: stream
        else
          render json: {error: true, message: "It was already stopped"}
        end
      end

      # Create new stream
      #
      # POST api/v1/streams/new
      # @see stream_params #stream_params for quering fields
      # @return [StreamSerializer]
      # @raise [{error: true, message: stream.errors}]
      def create
        stream = Stream.new(stream_params)
        if stream.save
          render json: stream
        else
          render json: {error: true, message: stream.errors}
        end
      end

      # Delete stream
      #
      # POST api/v1/streams/:id/delete
      # @return [{error: nil, message: "Deleted!"}]
      # @raise [{error: true, message: stream.errors}]
      def delete
        stream = Stream.find(params[:id])
        if stream.destroy
          render json: {error: nil, message: "Deleted!"}
        else
          render json: {error: true, message: stream.errors}
        end
      end

      # Returns list of stream by required period
      #
      # POST api/v1/streams/:id/delete
      # @see date_params #date_params for required fields
      # @return [{error: nil, message: "Deleted!"}]
      # @raise [{error: true, message: stream.errors}]
      def by_period
        started = DateTime.parse(date_params[:started])
        ended = DateTime.parse(date_params[:ended])
        streams = Stream.where(ended_at: started..ended)
        render json: streams
      end

      private
      # @!visibility public
      # Strong parameters for updating streams, requires namespace 'stream'
      #
      # @param _opts [Hash] Namespace 'stream'
      # @option _opts [Integer] :channel_id - Channel Id
      # @option _opts [Integer] :key_id - Key id
      # @option _opts [Integer] :user_id - User id
      # @option _opts [String] :game - *optional* Game title
      # @option _opts [String] :streamer - *optional* Streamer name
      # @option _opts [Date] :ended_at - *optional* End date
      def stream_params(_opts={})
        params.require(:stream).permit(:channel_id, :key_id, :user_id, :game, :streamer, :ended_at)
      end


      # @!visibility public
      # Strong parameters for updating streams, requires namespace 'date'
      #
      # @param _opts [Hash] Namespace 'date'
      # @option _opts [Date] :started - Start Date
      # @option _opts [Date] :ended - End Date
      def date_params(_opts={})
        params.require(:date).permit(:started, :ended)
      end
    end
  end
end
