require 'rails_helper'

RSpec.describe SignupsController, type: :controller do

  describe "#new " do
    it "should show signup page" do
      get :new
      expect(response.status).to eq(200)
    end
  end
  describe "#create " do
    it "should register new client" do
      params = {nickname: "new_client",
                password: "123456",
                confirm_password: "123456",
                email: "new_client@gmail.com"
      }
      post :create, session: {session_id: "new_client"}, params: params
      expect(response.status).to eq(302)
      expect(Client.last.nickname).to eql("new_client")
      expect(Session.where(session_id: "new_client").last).not_to be nil
    end

    it "should not register with wrong params" do
      params = {nickname: "new_client",
                password: "000",
                confirm_password: "123"
      }
      post :create, session: {session_id: "wrong_password"}, params: params
      expect(response.status).to eq(302)
      expect(Client.last).to be nil
    end
  end
end
