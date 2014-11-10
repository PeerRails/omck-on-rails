class UsersController < ApplicationController
  def login
  	@omniauth = request.env['omniauth.auth']
  	if User.find_by(uid: @omniauth[:uid]).nil?
	  	if @omniauth
	  		@user = User.new(
	  				:uid => @omniauth[:uid],
	  				:name => @omniauth[:info][:name],
	  				:screen_name => @omniauth[:info][:nickname],
	  				:profile_image_url => @omniauth[:info][:image],
	  				:gmod => false,
	  				:hd_channel => '',
	  				:streamer => false,
	  				:twitch => '',
	  				:access_token => @omniauth[:credentials][:token],
	  				:secret_token => @omniauth[:credentials][:secret],
	  				:login_last => DateTime.now,
	  				:last_ip => remote_ip
	  			)
	  		if @user.save
	  			flash[:info] = "Добро пожаловать, #{@user.name}!"
				session_create @user
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
		@user = User.find_by(uid: @omniauth[:uid])
		@user.last_ip = remote_ip
		@user.login_last = DateTime.now
		@user.profile_image_url = @omniauth[:info][:image]
		@user.name = @omniauth[:info][:name]
		@user.screen_name = @omniauth[:info][:nickname]
		@user.access_token = @omniauth[:credentials][:token]
		@user.secret_token = @omniauth[:credentials][:secret]
		if @user.save
			flash[:info] = "Добро пожаловать снова, #{@user.name}!"
			session_create @user
			redirect_to home_url
		else
			flash[:warning] = "Ошибка авторизации, попробуйте снова"
			redirect_to root_url
		end
	end
  end

  def grant_streamer
    user_params = params.require(:user).permit(:screen_name, :game, :movie)
    t_user = TClient.tclient.user(user_params[:screen_name])
    find_user = User.find_by_uid(t_user.id.to_s)
    if t_user.nil?
      flash[:danger] = "Данного твиттерского #{user_params[:screen_name]} не существует!"
    elsif find_user.nil?
      new_user = User.create { |user|
        user.uid = t_user.id
        user.name = t_user.name
        user.screen_name = t_user.screen_name
        user.profile_image_url = t_user.profile_image_url.to_s
        user.streamer = 1
      }
      key = Key.create(uid: new_user.id, streamer: new_user.name, game: user_params[:game] || "Boku no Pico", movie: user_params[:movie] || "Boku no Pico", key: SecureRandom.uuid)
      flash[:info] = "Новый стример создан! Пусть сюда зайдет через твиттер."
    elsif find_user.streamer == 1
      if Key.present.find_by_uid(find_user.id).nil?
        key = Key.create(uid: find_user.id, streamer: find_user.name, game: user_params[:game] || "Boku no Pico", movie: user_params[:movie] || "Boku no Pico", key: SecureRandom.uuid)
        flash[:info] = "Права обновлены."
      end
    elsif find_user.streamer == 0
      find_user.streamer = 1
      find_user.save
      key = Key.create(uid: find_user.id, streamer: find_user.name, game: user_params[:game] || "Boku no Pico", movie: user_params[:movie] || "Boku no Pico", key: SecureRandom.uuid) if Key.present.find_by_uid(find_user.id).nil?
      key.save if Key.present.find_by_uid(find_user.id).nil?
      flash[:info] = "Права обновлены."
    end
    redirect_to home_url
  end

  def logout
  	session_destroy
  	redirect_to root_url
  end
end
