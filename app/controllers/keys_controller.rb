class KeysController < ApplicationController
  load_and_authorize_resource

  def list
    keys = Key.present.where(user_id: current_user.id).map { |k| serialize k }
    render json: keys.first
  end

  def create
    if key_params[:user_id] && !key_owner(key_params[:user_id]).nil?
      if Key.present.where(user_id: key_params[:user_id]).empty?
        key = Key.new(key_params)
        key.user_id = current_user.id
        key.key = generate_key
        if key.save
          res = (serialize key).merge(status: 200)
        else
          res = { error: true, message: key.errors.full_messages, status: 500 }
        end
      else
        res = { error: true, message: 'You already have key', status: 403 }
      end
    else
      res = { error: true, message: 'Invalid data', status: 403 }
    end
    render json: res, status: res[:status]
  end

  def update
    if key_params[:user_id] && !key_owner(key_params[:user_id]).nil?
      key = Key.where(user_id: key_params[:user_id]).last
      key.streamer = key_params[:streamer] unless key_params[:streamer].nil?
      key.movie = key_params[:movie] unless key_params[:movie].nil?
      key.game = key_params[:game] unless key_params[:game].nil?
      if key.save
        res = (serialize key).merge(status: 200)
      else
        res = { error: true, message: key.errors.full_messages, status: 500 }
      end
    else
      res = { error: true, message: 'Not valid key', status: 500 }
    end
    render json: res, status: res[:status]
  end

  def expire
    if key_params[:user_id]
      key = Key.present.where(user_id: key_params[:user_id]).last
      unless key.nil?
        key.expires = DateTime.now
        key.save
        res = (serialize key).merge(status: 200)
      else
        res = { error: true, message: 'Key doesnt exists or already expired', status: 403 }
      end
    else
      res = { error: true, message: 'Invalid data', status: 403 }
    end
    render json: res, status: res[:status]
  end

  def regenerate
    if key_params[:user_id]
      key = Key.where(user_id: key_params[:user_id]).last
      unless key.nil?
        key.expires = DateTime.now
        key.save
        new_key = Key.new(user_id: key.user_id, streamer: key.streamer, movie: key.movie, game: key.game, guest: key.guest, expires: DateTime.now + 3600, key: generate_key)
        new_key.save
        res = (serialize new_key).merge(status: 200)
      else
        res = { error: true, message: 'Invalid key or already expired', status: 500 }
      end
    else
      res = { error: true, message: 'Invalid data', status: 500 }
    end
    render json: res, status: res[:status]
  end

  def key_params
    if params[:key]
      return params.require(:key).permit(:user_id, :streamer, :movie, :game, :guest, :expires)
    else
      return { user_id: nil, streamer: nil, movie: nil, game: nil, guest: nil, expires: nil }
    end
  end

  def generate_key
    SecureRandom.uuid
  end

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

  def key_owner(id)
    User.where(id: id).last
  end
end
