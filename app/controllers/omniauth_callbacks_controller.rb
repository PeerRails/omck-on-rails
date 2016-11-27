class OmniauthCallbacksController < ApplicationController
    before_action :omniauth

    def twitter
	   @account = @omniauth.login_with_twitter
	   if @account.nil?
		   redirect_to login_path, flash: {danger: "Error"}
	   else
		   @client = Client.find(@account.client_id)
		   @client.remember_at = DateTime.now + 99
		   @client.save
		   Session.create_session(@client, session[:session_id])
		   redirect_to home_path
	   end
    end

    def passthru
        render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end

    private
       	def omniauth
           	@omniauth = UserOmniAuth.new(request.env['omniauth.auth'])
       	end

end
