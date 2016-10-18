class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Pundit

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: {error: true, message: "Access Denied"}, status: 403 }
      format.html { redirect_to main_app.root_url, :alert => exception.message }
    end
  end

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    respond_to do |format|
      format.json { render json: {error: true, message: "Invalid Authenticity Token"}, status: 403 }
      format.html { redirect_to main_app.root_url, :alert => exception.message }
    end
  end

  rescue_from ActionController::ParameterMissing do
    respond_to do |format|
      format.json { render json: {error: true, message: "No valid params"}, status: 400 }
      format.html { redirect_to main_app.root_url, :alert => exception.message }
    end
  end

  rescue_from ActiveRecord::RecordNotFound do
    render json: {error: true, message: "Record not Found"}, status: 404
  end

  rescue_from Pundit::NotAuthorizedError do
    respond_to do |format|
      format.json { render json: {error: true, message: "You dont have access to this action"}, status: 400 }
      format.html { redirect_to main_app.root_url, :alert => "You dont have access to this action" }
    end
  end

  def tclient
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TICKET_1"]
      config.consumer_secret     = ENV["TICKET_2"]
      config.access_token        = ENV["TICKET_3"]
      config.access_token_secret = ENV["TICKET_4"]
    end
  end

  # :nocov:
  def bitly
    Bitly.use_api_version_3
    Bitly.new(ENV["BITLY_USER"], ENV["BITLY_TOKEN"])
  end
  # :nocov:

  def check_auth
    raise Pundit::NotAuthorizedError, "You dont have access to this action" unless current_user
  end

end
