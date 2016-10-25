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

end
