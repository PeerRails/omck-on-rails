class KeysController < ApplicationController
  before_filter :auth

  def generate_key
    return SecureRandom.uuid
  end


  def make_key
    if current_user.gmod == 1 ||  current_user.streamer == 1
      @key = Key.new( key_params )
      @key.key = generate_key

      if @key.guest?
        if @key.save
          flash[:success] = "Гостевой ключ создан! Выдайте #{@key.streamer} : #{@key.key}"
        else
          flash[:danger] = "Ошибка при регистрации ключа!"
        end
      else
        user = User.where(id: @key.user_id).last
        key = Key.where(user_id: @key.user_id).last
        if user.nil?
          flash[:danger] = "Такого пользователя нет!"
        elsif user.id != current_user.id
          flash[:danger] = "Систему не наебешь!"
        elsif !key.nil? && key.expires > DateTime.now
          flash[:danger] = "У пользователя уже есть ключ!"
        else
          if @key.save
            flash[:success] = "Ключ создан и выслан пользователю"
          else
            flash[:danger] = "Ошибка создания ключа!"
          end
        end
      end
    else
      flash[:danger] = "Недостаточно прав"
    end
    redirect_to home_url

  end

  def change_key
    @user_key = Key.where(user_id: current_user.id).last
    @user_key.streamer = key_params["streamer"] || "McDwarf"
    @user_key.game = key_params["game"] || "Boku no Pico"
    @user_key.movie = key_params["movie"] || "Boku no Pico"
    if @user_key.save
      flash[:success] = "Ключ обновлен!"
    else
      flash[:danger] = "Ошибка обновления!"
    end
    redirect_to home_url
  end

  def remake_key
    if current_user.gmod == 1
      key = params.permit(:key)
      @old_key = Key.where(key: key["key"]).last

      @new_key = Key.new(user_id: @old_key.user_id, streamer: @old_key.streamer, game: @old_key.game, movie: @old_key.movie, guest: )
      @new_key.expires = @old_key.expires
      @new_key.key = generate_key

      @old_key.expires = DateTime.now

      if @new_key.save && @old_key.save
        flash[:success] = "Ключ пересоздан! Выдайте #{@new_key.streamer} : #{@new_key.key}"
      else
        flash[:danger] = "Ошибка создания ключа!"
      end
        redirect_to home_url
    else
      flash[:danger] = "А Вы и не модер создавать ключи гостям!"
    end

  end

  def expire_key
    if current_user.gmod == 1
      key = params.permit(:id)
      if Key.update(key["id"], expires: DateTime.now)
        flash[:success] = "Ключ отвязан!"

      else
        flash[:danger] = "Ошибка отвязки ключа :с"
      end
    else
      flash[:danger] = "А Вы и не модер испарять ключи"
    end
    redirect_to home_url
  end

  def key_params
    params.require(:key).permit(:user_id, :streamer, :movie, :game, :guest, :expires)
  end

end
