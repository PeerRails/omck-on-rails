class UsersController < ApplicationController
  before_filter :auth, except: [:login]
  def login
  	@omniauth = request.env['omniauth.auth']
    if @omniauth.nil?
      flash[:warning] = "Ошибка авторизации, попробуйте снова"
      redirect_to root_url
    else
      user = User.login @omniauth, request.remote_ip
      if user.save
        Session.create_session(user, session[:session_id])
        flash[:success] = "Добро пожаловать, #{user.name}"
        redirect_to home_url
      else
        flash[:warning] = "Не удалась авторизация. Попробуйте снова."
        redirect_to root_url
      end
    end

  end

  def manage_perm
    user_params = params.require(:user).permit(:screen_name, :gmod, :streamer)
    if current_user.gmod == 1
      twitter_user = TClient.tclient.user(user_params[:screen_name])
      if twitter_user.nil?
        flash[:danger] = "Данного пользователя твиттера #{user_params[:screen_name]} не существует!"
      else
        user = User.find_by_twitter_id(twitter_user.id.to_s)
        if user.nil?
          user = User.create(
            twitter_id: twitter_user.id,
            name: twitter_user.name,
            screen_name: twitter_user.screen_name,
            profile_image_url: twitter_user.profile_image_url.to_s,
            streamer: user_params[:streamer] || 1,
            gmod: user_params[:gmod] || 0
          )

          key = Key.create(user_id: user.id, streamer: user.name, key: SecureRandom.uuid)
        else
          key = Key.create(user_id: user.id, streamer: user.name, key: SecureRandom.uuid) if user.streamer == 0 && user_params[:streamer] == 1 && Key.present.find_by_twitter_id(user.id).nil?
          user.streamer = user_params[:streamer] || 1
          user.gmod = user_params[:gmod] || 0
          user.save
          flash[:info] = "Права обновлены."
        end
      end
    else
      flash[:danger] = "Вы не админ."
    end

    redirect_to home_url

  end


  def remove_streamer
    if current_user.gmod == 1 || current_user.streamer == 1
      user_params = params.require(:user).permit(:id)
      user = User.find(user_params[:id])
      if user.nil?
        flash[:danger] = "Пользователя не существует"
      else
        User.update(user.id, streamer: 0)
        Key.where(user_id: user.id).each do |key|
          key.expires = DateTime.now
          key.save
        end
      end
      flash[:info] = "Права отобраны."
    else
      flash[:danger] = "Вы не админ."
    end
    redirect_to home_url
  end

  def logout
    Session.destroy_session(session[:session_id])
  	reset_session
  	redirect_to root_url
  end

end
