class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_client
      current_session.client || nil
  end

  # Return client object or nil
  # @params session [Hash]
  # @return [Session]
  def current_session
      Session.expired?(session[:session_id])
  end

end
