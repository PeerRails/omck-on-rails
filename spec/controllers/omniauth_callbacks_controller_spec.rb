require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
    describe "authorization through other services" do
        it "should login through twitter" do
            client = create(:client, :streamer)
            create(:account, client_id: client.id)
            request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
            post :twitter, session: {session_id: Faker::Internet.password }
            expect(response).to redirect_to home_path
        end
        it "should create new client" do
            request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
            expect{ post :twitter, session: {session_id: Faker::Internet.password } }.to change{Client.count}.by(1)
        end
    end

end
