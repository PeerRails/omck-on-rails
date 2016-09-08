class KeysController < ApplicationController
  before_action :check_auth

  def list
    key = Key.present.where(user_id: current_user.id).last
    if key.nil?
      new_key = Key.create(user_id: @current_user.id, guest: false, created_by: @current_user.id)
      render json: new_key, scope: current_user
    else
      render json: key, scope: current_user
    end
  end

  def streamers
    keys = Key.present.order(:id)
    render json: keys
  end

  def guests
    keys = Key.is_guest.order(:id)
    render json: keys
  end

  def secret
    key = Key.find(params[:id])
    authorize key
    render json: {key: {id: key.id, secret: key.key}}
  end

  def create
    key = Key.new(key_params)
    authorize key
    if key.save
      render json: key
    else
      render json: { error: true, message: key.errors }
    end
  end

  def create_guest
    guest = Key.new(user_id: current_user.id, streamer: key_params[:streamer], game: key_params[:game], movie: key_params[:movie], guest: true)
    authorize guest
    if guest.save
      render json: guest
    else
      render json: {error: true, message: guest.errors}
    end
  end

  def update
    key = User.find(key_params[:user_id]).keys.present.last
    authorize key
    if key.update(key_params_update)
      render json: key
    else
      render json: { error: true, message: key.errors }
    end
  end

  def expire
    key = User.find(key_params[:user_id]).keys.present.last
    authorize key unless key.nil?
    if !key.nil? && key.expire
      render json: key
    else
      render json: {error: true, message: 'Key doesnt exists or already expired'}
    end
  end

  def regenerate
    key = User.find(key_params[:user_id]).keys.present.last
    authorize key
    if key.expire
      new_key = Key.create(user_id: key.user_id, guest: false, streamer: key.streamer, game: key.game, movie: key.movie, created_by: @current_user.id)
      render json: new_key
    else
      render json: { error: true, message: "Key doesnt exists or already expired" }
    end
  end

  def expire_guest
    key = Key.where(id: params[:id], guest: true).where('expires > ?', DateTime.now).last
    authorize key
    if key.expire
      render json: key
    else
      render json: {error: true, message: key.errors}
    end
  end

  private
    def key_params
      params.require(:key).permit(:user_id, :guest, :streamer, :game, :movie)
    end

    def key_params_update
      params.require(:key).permit(:streamer, :game, :movie)
    end

end
