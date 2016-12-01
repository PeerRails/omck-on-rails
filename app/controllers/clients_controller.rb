class ClientsController < ApplicationController

    # View Registration
    # GET sign_up
    def new
    end

    # Register new client or redirect to login
    # POST client/create
    def create
        #client = Client.new(nickname: reg_params[:nickname], password: reg_params[:password])
        #if client.save
            #client_service = SessionService.new(client).attach_to_client(session[:session_id])
            #redirect_to home_path
        #else
            #redirect_to login_path
        #end
    end

    private
        def reg_params
            params.require(:client).permit(:nickname, :password)
        end
end
