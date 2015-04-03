class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def remote_ip
  	request.remote_ip
  end

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

  def check_session
    @session = nil
    if @session.empty? || @session.nil?
      redirect_to '/auth/twitter'
    end
  end

    def check_ip
      if remote_ip != "127.0.0.1"
        render json: error("403"), status: 403
      end
    end

end
