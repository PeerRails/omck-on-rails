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
        client = Client.where(nickname: login_params(:nickname)).first
        password = PasswordHandler.new(client)
        if password.valid_password?(login_params[:password])
            Session.create_session(session_id: session[:session_id], client_id: client.id)
        end
        redirect_to login_path
    end

    # Destroy session
    # POST session/destroy
    def destroy
        Session.destroy_session(session[:session_id])
        reset_session
        redirect_to login_path
    end

    def login_params
	params.require(:client).permit(:password, :nickname)
    end
end
