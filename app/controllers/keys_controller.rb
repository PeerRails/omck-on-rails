class KeysController < ApplicationController
  load_and_authorize_resource

  def list
    key = Key.present.where(user_id: @current_user.id).last
    if key.nil?
      raise ActiveRecord::RecordNotFound
    else
      render json: key
    end
  end

  def guests
    keys = Key.present.order(:id)
    render json: keys
  end

  def create
    key = Key.new(key_params)
    if key.save
      render json: key
    else
      render json: { error: true, message: key.errors }
    end
  end

  def create_guest
    guest = Key.new(user_id: current_user.id, streamer: key_params[:streamer], game: key_params[:game], movie: key_params[:movie], guest: true)
    if guest.save
      render json: guest
    else
      render json: {error: true, message: guest.errors}
    end
  end

  def update
    key = User.find(key_params[:user_id]).keys.present.last
    key.update(key_params_update)
    if key.save
      render json: key
    else
      render json: { error: true, message: key.errors }
    end
  end

  def expire
    key = User.find(key_params[:user_id]).keys.present.last
    if !key.nil? && key.expire
      render json: key
    else
      render json: {error: true, message: 'Key doesnt exists or already expired'}
    end
  end

  def regenerate
    key = User.find(key_params[:user_id]).keys.present.last
    if key.expire
      new_key = Key.create(user_id: key.user_id, guest: false, streamer: key.streamer, game: key.game, movie: key.movie, created_by: @current_user.id)
      render json: new_key
    else
      render json: { error: true, message: "Key doesnt exists or already expired" }
    end
  end

  def expire_guest
    key = Key.where(id: params[:id], guest: true).where('expires > ?', DateTime.now).last
    if key.expire
      render json: key
    else
      render json: {error: true, message: key.errors}
    end
  end

  def key_params
    params.require(:key).permit(:user_id, :guest, :streamer, :game, :movie)
  end

  def key_params_update
    params.require(:key).permit(:streamer, :game, :movie)
  end

end
