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

  def logout
  	session_destroy
  	redirect_to root_url
  end
end
