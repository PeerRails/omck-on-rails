class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: {error: true, message: "You dont have access to this action"}, status: 403 }
      format.html { redirect_to main_app.root_url, :alert => exception.message }
    end
  end

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    respond_to do |format|
      format.json { render json: {error: true, message: "You dont have access to this action"}, status: 403 }
      format.html { redirect_to main_app.root_url, :alert => exception.message }
    end
  end

  rescue_from ActionController::ParameterMissing do
    respond_to do |format|
      format.json { render json: {error: true, message: "No valid params"}, status: 400 }
      format.html { redirect_to main_app.root_url, :alert => exception.message }
    end
  end

  def tclient
    tclient = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TICKET_1"]
      config.consumer_secret     = ENV["TICKET_2"]
      config.access_token        = ENV["TICKET_3"]
      config.access_token_secret = ENV["TICKET_4"]
    end
  end

end
