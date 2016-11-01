class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_client
      current_session.nil? ? nil : current_session.client
  end

  # Return client object or nil
  # @params session [Hash]
  # @return [Session | nil]
  def current_session
      Session.expired?(session[:session_id])
  end

end
