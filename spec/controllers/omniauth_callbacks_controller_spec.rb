require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do

  describe "#login" do
    it "should not login through invalid provider" do
      get :passthru, params: {provider: "omcktv"}
      expect(response.status).to eq(404)
    end

    it "should not login if invalid omniauth" do
      request.env["omniauth.auth"] = nil
      get :login, params: {provider: 'twitter'}, session: {session_id: "wrong"}
      session = Session.where(session_id: "wrong").first
      expect(response.status).to eq(302)
      expect(session).to be nil
    end
  end

  describe "#login twitter" do
    it "should login through twitter" do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      get :login, params: {provider: 'twitter'}
      expect(response.status).to eq(302)
    end

    it "should authorize registered client" do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      get :login, params: {provider: 'twitter'}, session: {session_id: "first"}
      get :login, params: {provider: 'twitter'}, session: {session_id: "second"}
      session = Session.where(session_id: "second").first
      expect(response.status).to eq(302)
      expect(session.client.nickname).to eq("johnqpublic")
    end
  end

  describe "#login twitch" do
     it "should login" do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitch]
      get :login, params: {provider: 'twitch'}, session: {session_id: "twitch"}
      session = Session.where(session_id: "twitch").first
      expect(response.status).to eq(302)
      expect(session.client.nickname).to eq("johndoe")
    end
  end

end
