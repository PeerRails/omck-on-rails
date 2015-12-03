class KeysController < ApplicationController

  def generate_key
    SecureRandom.uuid
  end

  def list
    keys = Key.all.map { |k| serialize k }
    render json: keys
  end

  def create
    if key_params[:user_id] && !User.where(id: key_params[:user_id]).last.nil?
      if Key.where(user_id: key_params[:user_id]).present.empty?
        key = Key.new(key_params)
        key.key = generate_key
        if key.save
          response = (serialize key).merge({status: 200})
        else
          resonse = {error: true, message: key.errors.full_messages, status: 500}
        end
      else
        response = {error: true, message: "You already have key", status: 403}
      end
    else
      response = {error: true, message: "Invalid data", status: 403}
    end
    render json: response, status: response[:status]
  end

  def expire
    if key_params[:user_id]
      key = Key.where(user_id: key_params[:user_id]).present.last
      unless key.nil?
        key.expires = DateTime.now
        key.save
        response = (serialize key).merge({status: 200})
      else
        response = {error: true, message: "Key doesnt exists or already expired", status: 403}
      end
    else
      response = {error: true, message: "Invalid data", status: 403}
    end
    render json: response, status: response[:status]
  end

  def update
    if key_params[:user_id]
      key = Key.where(user_id: key_params[:user_id]).present.last
      key.streamer = key_params[:streamer]
      key.movie = key_params[:movie]
      key.game = key_params[:game]
      if key.save
        response = (serialize key).merge({status: 200})
      else
        response = {error: true, message: "Invalid data", status: 500}
      end
    else
      response = {error: true, message: "Invalid data", status: 500}
    end
    render json: response, status: response[:status]
  end

  def regenerate
    if key_params[:user_id]
      key = Key.where(user_id: key_params[:user_id]).present.last
      unless key.nil?
        key.expires = DateTime.now
        key.save
        new_key = Key(key_params)
        new_key.save
        response = (serialize new_key).merge({status: 200})
      else
        response = {error: true, message: "Invalid data", status: 500}
      end
    else
      response = {error: true, message: "Invalid data", status: 500}
    end
    render json: response, status: response[:status]
  end

  def key_params
    params.require(:key).permit(:user_id, :streamer, :movie, :game, :guest, :expires)
  end

  private
  def serialize(key)
    { streamer: key.streamer,
      movie: key.movie,
      game: key.game,
      guest: key.guest,
      expires: key.expires,
      user: key.user.name,
      secret: key.key,
      'error' => nil }
  end
end
