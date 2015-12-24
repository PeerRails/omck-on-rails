class KeysController < ApplicationController
  load_and_authorize_resource

  def list
    keys = Key.present.where(user_id: current_user.id).map { |k| serialize k }
    render json: keys.first
  end

  def guests
    keys = Key.is_guest.map { |k| serialize k }
    render json: keys
  end

  def create
    if key_params[:user_id] && !key_owner(key_params[:user_id]).nil?
      if Key.present.where(user_id: key_params[:user_id]).empty?
        key = Key.new(key_params)
        key.created_by = current_user.id
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

  def create_guest
    if Key.where(created_by: current_user.id, guest: true).count < 5 || current_user.screen_name == "omckws"
      guest = Key.create(created_by: current_user.id, streamer: key_params[:streamer], game: key_params[:game], movie: key_params[:movie], key: generate_key, guest: true)
      res = serialize guest
      res[:secret] = guest.key
    else
      res = {error: true, message: "Too Many Invites"}
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
      key = Key.present.where(user_id: key_params[:user_id]).last
      unless key.nil?
        key.expires = DateTime.now
        key.save
        new_key = Key.new(user_id: key.user_id, streamer: key.streamer, movie: key.movie, game: key.game, guest: key.guest, expires: DateTime.now + 3600, key: generate_key, created_by: key.user.id)
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

  def expire_guest
    key = Key.where(id: params[:id], guest: true).where('expires > ?', DateTime.now).last
    unless key.nil?
      key.expires = DateTime.now
      if key.save
        res = (serialize key).merge(status: 200)
      else
        res = { error: true, message: key.errors.full_messages, status: 500 }
      end
    else
      res = { error: true, message: 'Invalid key or already expired', status: 500 }
    end
    render json: res, status: res[:status]
  end

  def key_params
    if params[:key]
      return params.require(:key).permit(:user_id, :streamer, :movie, :game, :expires)
    else
      return { user_id: nil, streamer: nil, movie: nil, game: nil, guest: nil, expires: nil }
    end
  end

  def generate_key
    SecureRandom.uuid
  end

  def serialize(key)
    guest_id = key.guest == false ? nil : key.id
    secret = key.guest == false ? key.key : nil
    return { guest_id: guest_id,
        streamer: key.streamer,
        movie: key.movie,
        game: key.game,
        guest: key.guest,
        expires: key.expires,
        created_by: User.where(id: key.created_by).last.twitter_id,
        created_by_name: User.where(id: key.created_by).last.name,
        secret: secret,
        'error' => nil }
  end

  def key_owner(id)
    User.where(id: id).last
  end
end
