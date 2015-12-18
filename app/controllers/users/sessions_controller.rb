class Users::SessionsController < ApplicationController
  def new
    if user_signed_in?
      redirect_to home_path      
    end
  end

  def destroy
    sign_out
    redirect_to home_path
  end
end
