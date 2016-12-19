class OmniauthCallbacksController < ApplicationController
    before_action :set_provider
    attr_accessor :omniauth, :provider

    def login
      client = @provider.authorize(@omniauth)
	    if client.nil?
		    redirect_to login_path, flash: {danger: "Error"}
	    else
		    client.remember_at = DateTime.now + 99
        client.last_ip = request.ip
        client.last_login = DateTime.now
		    client.save
        SessionService.new(client)
                      .attach_to_client(session[:session_id])
        puts client.inspect
		    redirect_to home_path
	    end
    end

    def passthru
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end

    private
     	def set_provider
        @omniauth = request.env['omniauth.auth']
        return nil if @omniauth.nil?
        @provider = UserOmniAuth.new(TwitterOmniAuth.new) if @omniauth['provider'] == 'twitter'
     	end
end
