require 'rails_helper'

RSpec.describe ApiTokensController, type: :controller do
  before do
    @user = create(:user)
    @streamer = create(:user, :streamer)
    @token = create(:api_token, user_id: @user.id)
    request.env["HTTP_ACCEPT"] = 'application/json'
    sign_in @user
  end

  describe "GET #list" do
    it "should show api tokens for user" do
      get :list
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["tokens"][0]["user_id"]).to eq(@user.id)
    end
  end

  describe "GET #tokens" do
    it "should show all api token for gmod" do
      @user.update(gmod: 1)
      create(:api_token, user_id: @streamer.id, secret: "dadada")
      get :list_all
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["tokens"].count).to eq(2)
    end
  end

  describe "GET #show" do
    it "should show api token of specific user" do
      get :show, user_id: @user.id
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["token"]["user_id"]).to eq(@user.id)
    end
  end

  describe "POST #create" do
    it "should create new api token for user" do
      @token.destroy
      post :create, user_id: @user.id
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["token"]["user_id"]).to eq(@user.id)
    end
  end

  describe "DELETE #delete" do
    it "should create new api token for user" do
      @token.destroy
      post :create, user_id: @user.id
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["token"]["user_id"]).to eq(@user.id)
    end
  end

  describe "expire #expire" do
    it "should expire api token for user" do
      post :expire, id: @token.id
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["message"]).to eq("Expired!")
    end
  end
end
