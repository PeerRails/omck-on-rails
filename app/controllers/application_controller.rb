class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Return [Client] or nil
  def current_client
      current_session.nil? ? nil : current_session.client
  end

  # Return [Session] or nil
  def current_session
      return false if session['session_id'].nil?
      Session.expired?(session['session_id'])
  end

end
