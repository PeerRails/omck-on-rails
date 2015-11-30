class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def auth
    if current_user.nil?
      redirect_to 'home/login'
    else
      return true
    end
  end

  def check_ip
    unless request.remote_ip.include? '172.17.' || request.remote_ip == '127.0.0.1'
      render json: { status: 403, message: 'Forbidden' }, status: 403
    end
  end

  def current_user
    @current_user ||= User.select('users.*, sessions.ip, sessions.expires')
                      .joins(:sessions)
                      .where(sessions: { session_id: session[:session_id]})
                      .last if session[:session_id].present?
    if @current_user && @current_user.expires < DateTime.now
      reset_session
      @current_user = nil
    end
    @current_user
  end

  helper_method :current_user
end
