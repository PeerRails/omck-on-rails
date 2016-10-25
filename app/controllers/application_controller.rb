class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def check_auth
    raise Pundit::NotAuthorizedError, "You dont have access to this action" unless current_user
  end

end
