class ApiApplicationController < ActionController::API
  include ActionController::Serialization
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
end
