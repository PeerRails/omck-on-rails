class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_client
      current_client.user || nil
  end

  def current_session
      Session.expired?(session[:session_id])
  end

end
