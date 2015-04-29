class NginxController < ApplicationController
  before_filter :check_ip, :only => [:end_cinema, :move_record, :increase_viewer_count, :decrease_viewer_count, :get_key]
  def get_key
    streamer = Key.where(key: params_key[:key]).last if params_key[:name]
    if params_key[:name] == "omcktv"
      if streamer.nil?
        render json: error("403"), status: 403
      else
        channel = "hdgames" if params_key[:app] == "live"
        channel = "hdkinco" if params_key[:app] == "cinema"

        update_chan = Channel.where(:service => "hd", channel: channel).last
        update_chan.live = true
        update_chan.game = streamer.game if channel == "hdgames"
        update_chan.game = streamer.movie if channel == "hdkinco"
        update_chan.title = streamer.game
        update_chan.save
        render json: error("200"), status: 200
      end
    else
        render json: error("403"), status: 403
    end
  end

  def move_record
    if params_key[:key]
      channel = Channel.where(:service => "hd", :channel => "hdgames").last
      channel.toggle!(:live)
      streamer = Key.where(key: params_key[:key]).last
      if params_key[:path]
        if streamer.nil?
          File.delete(params_key[:path])
        else
          new_file = "/var/www/uploaded/#{streamer.streamer.gsub(/\s+/, '_')}_-_#{streamer.game.gsub(/\s+/, '_')}_#{DateTime.now.strftime('%Y-%m-%d-%H-%M-%S')}.flv"
          File.rename(params_key[:path], new_file)
          video = Video.create!(
            key_id: streamer.id,
            user_id: streamer.user_id,
            game: streamer.game,
            path: new_file,
            description: "#{streamer.game} by #{streamer.streamer}",
            uid: SecureRandom.hex(6)
            )
        end
      end
      render json: error("200"), status: 200
    else
      render json: error("403"), status: 200
    end
  end

  def end_cinema
    if params_key[:key]
      channel = Channel.where(:service => "hd", :channel => "hdkinco").last
      channel.toggle!(:live)
      render json: error("200"), status: 200
    else
      render json: error("403"), status: 200
    end
  end

  def increase_viewer_count
    if params_key[:app]
      channel = Channel.where(:service => "hd", :channel => "hdgames").last if params_key[:app] == "live"
      channel = Channel.where(:service => "hd", :channel => "hdkinco").last if params_key[:app] == "cinema"
      channel.increment!(:viewers)
    end
    render json: params, status: 200
  end

  def decrease_viewer_count
    if params_key[:app]
      channel = Channel.where(:service => "hd", :channel => "hdgames").last if params_key[:app] == "live"
      channel = Channel.where(:service => "hd", :channel => "hdkinco").last if params_key[:app] == "cinema"
      channel.decrement!(:viewers)
    end
    render json: params, status: 200
  end

  private
  def params_key
  	params.permit(:key, :name, :path, :app, :addr, :call, :type)
  end
end
