class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	def error code
		case code
		when "404"
			error_msg = {"error" => "Nothing found", "status" => 404}
    when "200"
        error_msg = {"success" => true, "status" => 200}
    when "403"
        error_msg = {"error" => "Access Denied", "status" => 403}
		when "502"
			error_msg = {"error" => "Server error", "status" => 502}
    when "nostream"
      error_msg = {"error" => "nostream", "status" => 200}
		else
			error_msg = {"error" => "Unknown error", "status" => 500}
		end
		return error_msg
	end

  def auth
    if current_user.nil?
      redirect_to '/auth/twitter'
    else
      return true
    end
  end

    def check_ip
      if request.remote_ip != "127.0.0.1"
        render json: error("403"), status: 403
      end
    end

    def current_user
      @current_user ||= User.select("users.*, sessions.ip, sessions.expires").joins(:sessions).where(sessions: {session_id: session[:session_id]}).last if session[:session_id].present?
      if @current_user && ((request.remote_ip != @current_user.ip && request.remote_ip != "127.0.0.1") || @current_user.expires < DateTime.now)
        reset_session
        @current_user = nil
      end
      return @current_user
    end

    helper_method :current_user
    
end
