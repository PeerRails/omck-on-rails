class ClientsController < ApplicationController

     # Register new client or redirect to login
     # POST client/create
    def create
        client = PasswordHandler.new( Client.new(nickname: reg_params[:nickname], password: reg_params[:password]) )
        client.salt_password
        if client.save
            redirect_to login_path
        else
            redirect_to login_path
        end
    end

    private
        def reg_params
            params.require(:client).permit(:name, :password)
        end
end
