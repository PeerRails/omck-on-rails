class SessionController < ApplicationController

    # Show login page
    # GET login
    def login
        if current_client
            redirect_to home_path
        else
            respond_to do |format|
                format.html {render "session/login"}
            end
        end
    end

    # Authorize client by nickname and save his session
    # POST session/create
    def create
        client = Client.find_by_email(login_params[:email])
        password = PasswordHandler.new(client)
        if password.valid_password?(login_params[:password])
            Session.create_session(session_id: session[:session_id], client_id: client.id)
        end
        redirect_to login_path
    end

    # Register new client or redirect to login
    def register
        client = Client.new(name: login_params[:name], nickname: login_params[:email])
        if client.save
            EmailConfirmationToken.create(client_id: client.id)
            # Should send new password
            # send_mail_with_first_password
            redirect_to login_path
        else
            redirect_to login_path
        end
    end

    def logout
        Session.destroy_session(session[:session_id])
        reset_session
        redirect_to login_path
    end

    def login_params
        params.permit(:password, :nickname)
    end
end
