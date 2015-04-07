class UsersController < ApplicationController
  before_filter :auth, except: [:login]
  def login
  	@omniauth = request.env['omniauth.auth']
  	if User.find_by(twitter_id: @omniauth[:uid]).nil?
	  	if @omniauth
	  		@user = User.new(
	  				:twitter_id => @omniauth[:uid],
	  				:name => @omniauth[:info][:name],
	  				:screen_name => @omniauth[:info][:nickname],
	  				:profile_image_url => @omniauth[:info][:image],
	  				:gmod => false,
	  				:streamer => false,
	  				:access_token => @omniauth[:credentials][:token],
	  				:secret_token => @omniauth[:credentials][:secret],
	  				:login_last => DateTime.now,
	  				:last_ip => remote_ip
	  			)
	  		if @user.save
	  			flash[:info] = "Добро пожаловать, #{@user.name}!"
          create_session(@user, session[:session_id])
	  			redirect_to home_url
	  		else
	  			flash[:warning] = "Ошибка авторизации, попробуйте снова"
	  			redirect_to root_url
	  		end
	    else
	    	flash[:warning] = "Ошибка авторизации, попробуйте снова"
	    	redirect_to root_url
	  	end
	else
		@user = User.find_by(twitter_id: @omniauth[:uid])
		@user.last_ip = remote_ip
		@user.login_last = DateTime.now
		@user.profile_image_url = @omniauth[:info][:image]
		@user.name = @omniauth[:info][:name]
		@user.screen_name = @omniauth[:info][:nickname]
		@user.access_token = @omniauth[:credentials][:token]
		@user.secret_token = @omniauth[:credentials][:secret]
		if @user.save
			flash[:info] = "Добро пожаловать снова, #{@user.name}!"
      create_session(@user, session[:session_id])
			redirect_to home_url
		else
			flash[:warning] = "Ошибка авторизации, попробуйте снова"
			redirect_to root_url
		end
	end
  end

  def manage_perm
    user_params = params.require(:user).permit(:screen_name, :gmod, :streamer)
    twitter_user = TClient.tclient.user(user_params[:screen_name])

    if twitter_user.nil?
      flash[:danger] = "Данного твиттерского #{user_params[:screen_name]} не существует!"
    else
      user = User.find_by_twitter_id(twitter_user.id.to_s)
      if user.nil?
        user = User.create( twitter_id: twitter_user.id, name: twitter_user.name, screen_name: twitter_user.screen_name, profile_image_url: twitter_user.profile_image_url.to_s, streamer: user_params[:streamer] || 1, gmod: user_params[:gmod] || 0)
        key = Key.create(user_id: user.id, streamer: user.name, key: SecureRandom.uuid)
      else
        key = Key.create(user_id: user.id, streamer: user.name, key: SecureRandom.uuid) if user.streamer == "0" && user_params[:streamer] == 1 && Key.present.find_by_twitter_id(user.id).nil?
        user.streamer = user_params[:streamer] || 1
        user.gmod = user_params[:gmod] || 0
        user.save
        flash[:info] = "Права обновлены."
      end
    end

    redirect_to home_url

  end


  def remove_streamer
    user_params = params.require(:user).permit(:id)
    user = User.find(user_params[:id])
    if user.nil?
      flash[:danger] = "Пользователя не существует"
    else
      user.update(streamer: 0)
      Key.update(user_id: user.id, expires: DateTime.now)
    end
    redirect_to home_url
  end

  def logout
  	reset_session
  	redirect_to root_url
  end
end
