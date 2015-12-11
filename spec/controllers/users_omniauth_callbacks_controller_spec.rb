require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  describe "GET #twitter" do
    it "should authorize user" do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      get :user_omniauth_authorize, provider: "twitter"
      expect(response).to redirect_to root_path
    end
    it "should redirect to root" do
      admin = create(:user, :admin)
      sign_in :user, admin
      get :user_omniauth_authorize, provider: "twitter"
      expect(response).to redirect_to root_path
    end
  end
end
