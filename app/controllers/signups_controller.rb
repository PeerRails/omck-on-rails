class SignupsController < ApplicationController

    # Signup Form
    # GET /signup
    def new
    end

    # Create new client
    # POST signup/create
    def create
      form = SignupForm.new(signup_params)
      if form.valid?
        client = form.signup
        client.last_ip = request.ip
        SessionService.new(client)
                      .attach_to_client(session[:session_id])
        redirect_to home_path
      else
        redirect_to signup_new_path
      end
    end

    def signup_params
      params.permit(:password, :confirm_password, :email, :nickname)
    end

end
