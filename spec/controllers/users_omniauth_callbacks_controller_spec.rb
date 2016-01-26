require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end
  describe "POST #twitter" do
    it "should auth with twitter" do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      post :twitter
      expect(response).to redirect_to home_path
    end
    it "should redirect to home if omni auth is wrong" do
      request.env["omniauth.auth"] = nil
      post :twitter
      expect(response).to redirect_to home_path
    end
    it "should redirect to new session if omni auth is persisted" do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      post :twitter
      expect(response).to redirect_to home_path
    end
  end
end
