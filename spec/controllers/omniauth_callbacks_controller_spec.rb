require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do

  describe "#login" do
    it "should not login through invalid provider" do
      get :passthru, params: {provider: "omcktv"}
      expect(response.status).to eq(404)
    end
    it "should login through twitter" do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      get :login, params: {provider: 'twitter'}
      expect(response.status).to eq(302)

    end
  end
end
