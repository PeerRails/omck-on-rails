class ApiApplicationController < ActionController::API
  include CanCan::ControllerAdditions
  include ActionController::Serialization

  before_action :check

  private
  def check
      token = request.headers["HTTP_API_TOKEN"] || nil
      @current_user = User.new
      @current_user = ApiToken.where(secret: token).present.user unless token.nil? || ApiToken.find_by_secret(token).nil?
      @current_ability ||= Ability.new(@current_user)
  end

  # Clients
  # :nocov:
    def tclient
      Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TICKET_1"]
        config.consumer_secret     = ENV["TICKET_2"]
        config.access_token        = ENV["TICKET_3"]
        config.access_token_secret = ENV["TICKET_4"]
      end
    end

    def bitly
      Bitly.use_api_version_3
      Bitly.new(ENV["BITLY_USER"], ENV["BITLY_TOKEN"])
    end
  # :nocov:

  rescue_from CanCan::AccessDenied do
    render json: {error: true, message: "Access Denied"}, status: 403
  end

  rescue_from ActionController::InvalidAuthenticityToken do
    render json: {error: true, message: "Invalid Authenticity Token"}, status: 403
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

  rescue_from ActionController::RoutingError do
    render json: {error: true, message: "404 Not Found"}
  end

end
