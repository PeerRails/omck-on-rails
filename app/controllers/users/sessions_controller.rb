class Users::SessionsController < ApplicationController
  def new
    if current_user
      redirect_to root_url
    else
      render json: {error: true}
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
