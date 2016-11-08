class OmniauthCallbacksController < ApplicationController

    def twitter
        @account = Account.login_with_twitter(request.env['omniauth.auth'])
        if @account.nil?
            redirect_to login_path, flash: {danger: "Ой, что-то сломалось"}
        elsif @account.persisted?
            @client = Client.find(@account.client_id)
            @client.remember_at = DateTime.now + 99
            Session.create_session(@client, session[:session_id])
            redirect_to home_path
        else
            redirect_to login_path
        end
    end

    def passthru
        render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end

end
