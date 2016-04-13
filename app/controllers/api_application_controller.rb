class ApiApplicationController < ActionController::API
  include ActionController::Serialization
  respond_to :json

  def check
    token = request.headers["HTTP_API_TOKEN"] || nil
    user = User.new
    user = ApiToken.where(secret: token).present.user unless token.nil? || ApiToken.find_by_secret(token).nil?
    render json: user
  end

  def auth_api
    #placeholder
  end

  def tclient
    tclient = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TICKET_1"]
      config.consumer_secret     = ENV["TICKET_2"]
      config.access_token        = ENV["TICKET_3"]
      config.access_token_secret = ENV["TICKET_4"]
    end
  end

  rescue_from CanCan::AccessDenied do |e|
    render json: {error: true, message: "You dont have access to this action"}, status: 403
  end

  rescue_from ActionController::InvalidAuthenticityToken do |e|
    render json: {error: true, message: "You dont have access to this action"}, status: 403
  end

  rescue_from ActionController::ParameterMissing do
    render json: {error: true, message: "No valid params"}, status: 403
  end

  rescue_from ActiveRecord::RecordNotFound do
    render json: {error: true, message: "Record not Found"}, status: 404
  end

  rescue_from Twitter::Error do |e|
    render json: {error: true, message: e}
  end
end
