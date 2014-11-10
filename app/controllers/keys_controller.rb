class KeysController < ApplicationController
  before_filter :check_session
  def generate_key
    return SecureRandom.uuid
  end


  def make_key
    @key = Key.new( params.require(:key).permit(:uid, :streamer, :movie, :game, :guest, :expires) )
    @key.key = generate_key

    if @key.guest?
      if @key.save
        flash[:success] = "Гостевой ключ создан! Выдайте #{@key.streamer} : #{@key.key}"
      else
        flash[:danger] = "Ошибка при регистрации ключа!"
      end
    else
      user = User.where(id: @key.uid).last
      key = Key.where(uid: @key.uid).last
      if user.nil?
        flash[:danger] = "Такого пользователя нет!"
      elsif user.id != @session["id"].to_i
        flash[:danger] = "Систему не наебешь!"
      elsif !key.nil? && key.expires > DateTime.now
        flash[:danger] = "У пользователя уже есть ключ!"
      else
        if @key.save
          flash[:success] = "Ключ создан! Выдайте #{@key.streamer} : #{@key.key}"
        else
          flash[:danger] = "Ошибка создания ключа!"
        end
      end
    end
    redirect_to home_url

  end

  def change_key
      @new_key = params.require(:key).permit(:streamer, :game, :movie)
      @user_key = Key.where(uid: @session["id"]).last
      @user_key.streamer = @new_key["streamer"]
      @user_key.game = @new_key["game"]
      @user_key.movie = @new_key["movie"]
      if @user_key.save
        flash[:success] = "Обновлено!"
      else
        flash[:danger] = "Ошибка обновления!"
      end
      redirect_to home_url
  end

  def remake_key
    key = params.permit(:key)
    @old_key = Key.where(key: key["key"]).last
    #@old_key.expires = DateTime.now

    @new_key = Key.new(uid: @old_key.uid,streamer: @old_key.streamer,game: @old_key.game,movie: @old_key.movie,guest: @old_key.guest)
    @new_key.expires = @old_key.expires
    @new_key.key = generate_key

    if @new_key.save && @old_key.save
      flash[:success] = "Ключ пересоздан! Выдайте #{@new_key.streamer} : #{@new_key.key}"
    else
      flash[:danger] = "Ошибка создания ключа!"
    end
    if @new_key.guest?
      redirect_to guest_room_url(key["key"])
    else
      redirect_to home_url
    end

  end

  def expire_key
    key = params.permit(:id)
    if Key.update(key["id"], expires: DateTime.now)
      flash[:success] = "Ключ отвязан!"
    else
      flash[:danger] = "Ошибка отвязки ключа :с"
    end
    redirect_to home_url

  end

end
