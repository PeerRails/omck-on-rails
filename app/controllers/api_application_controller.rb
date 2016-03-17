class ApiApplicationController < ActionController::API
  include ActionController::Serialization
  respond_to :json

  def check
    token = request.headers["HTTP_API_TOKEN"] || nil
    user = User.new
    user = ApiToken.where(secret: token).present.user unless token.nil? || ApiToken.find_by_secret(token).nil?
    render json: user
  end

  private
  def auth_api
    #placeholder
  end

  rescue_from CanCan::AccessDenied do |exception|
    render json: {error: true, message: "You dont have access to this action"}, status: 403
  end

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    render json: {error: true, message: "You dont have access to this action"}, status: 403
  end

  rescue_from ActionController::ParameterMissing do
    render json: {error: true, message: "No valid params"}, status: 403
  end
end
