module Api
  module V1
    class MainController < ApiApplicationController
      def check
        render json: request.headers["HTTP_API_TOKEN"]
      end
    end
  end
end
