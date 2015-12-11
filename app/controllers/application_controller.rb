class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def auth
    if !current_user
      render json: {error: true, message: "You must be logged", status: 403}
    end
  end
end
