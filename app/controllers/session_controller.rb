class SessionController < ApplicationController

    # Show login page
    def login
        respond_to do |format|
            format.html {render "session/login"}
        end
    end

    # Authorize client and save his session
    def enter
        client = Client.find_by_email(login_params[:email])
        if client && client.valid_password?(login_params[:password])
            Session.create_session(client, session[:session_id])
        end
        redirect_to login_path
    end

    # Register new client or redirect to login
    def register
        client = Client.new(name: login_params[:name], email: login_params[:email])
        if client.save
            EmailConfirmationToken.create(client_id: client.id)
            redirect_to login_path
        else
            redirect_to login_path
        end
    end

    def logout
        Session.destroy_session(session[:session_id])
        redirect_to login_path
    end

    def verify
        token = EmailConfirmationToken.where(secret: params[:token]).first
        if token && !token.confirmed
            token.update_client
            @message = "ты пидор"
        else
            raise !token.confirmed.inspect
            @message = "ты ошибка"
        end
    end

    def forgot_password
    end

    def login_params
        params.permit(:email, :password, :name)
    end
end
