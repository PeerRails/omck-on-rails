class SessionController < ApplicationController

    # Show login page
    # GET login
    # GET sessions/login
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
    # POST sessions
    def create
        client = Client.where(nickname: login_params[:nickname]).first
        password = PasswordHandler.new(client)
        client_session = SessionService.new(client)
        if client && password.valid_password?(login_params[:password])
           client.last_ip = request.ip
           client_session.attach_to_client(session[:session_id])
           redirect_to home_path
        else
          redirect_to login_path
        end
    end

    # Destroy session
    # DELETE sessions
    def destroy
        client_session = SessionService.new(current_client)
        client_session.destroy(session[:session_id])
        reset_session
        redirect_to login_path
    end

    private
        def login_params
            params.require(:client).permit(:password, :nickname)
        end
end
