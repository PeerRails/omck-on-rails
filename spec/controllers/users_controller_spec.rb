require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #show" do
    before do
      @user = create(:user, :streamer)
      sign_in @user
      request.env["HTTP_ACCEPT"] = 'application/json'
    end
    it "should show user information" do
      get :show, twitter_id: @user.twitter_id
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["twitter_id"]).to eq(@user.twitter_id)
    end
    it "should return error with incorrect id" do
      get :show, twitter_id: "0000"
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json["message"]).to eq("User not found")
    end
  end
  describe "get #videos" do
    before do
      @user = create(:user, :streamer)
      sign_in @user
      request.env["HTTP_ACCEPT"] = 'application/json'
    end
    it "should return list of videos" do
      vid = create(:video, user_id: @user.id)
      get :videos, twitter_id: @user.twitter_id
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["videos"][0]["token"]).to eq(vid.token)
    end
    it "should return error with incorrect user" do
      vid = create(:video, user_id: @user.id)
      get :videos, twitter_id: "11114"
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json["message"]).to eq("User or videos not found")
    end
  end
  #describe "POST #update" do
  #  before do
  #    @user = create(:user, :streamer)
  #  end
  #  it "should update user data" do
  #    expect(true).to be true
  #  end
  #end
  describe "POST #grant" do
    before do
      @user = create(:user)
      @streamer = create(:user, :mod)
      sign_in @streamer
      request.env["HTTP_ACCEPT"] = 'application/json'
    end
    it "should grant stream permission" do
      post :grant, twitter_id: @user.twitter_id, permissions: {streamer: 1}
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["twitter_id"]).to eq(@user.twitter_id)
      expect(@user.streamer).to eq(0)
      expect(@user.keys.length).to be > 0
      expect(User.find(@user.id).streamer).to eq(1)
    end
    it "should grant mod permission" do
      post :grant, twitter_id: @user.twitter_id, permissions: {gmod: 1}
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["twitter_id"]).to eq(@user.twitter_id)
      expect(@user.gmod).to eq(0)
      expect(User.find(@user.id).gmod).to eq(1)
    end
    it "should grant both mod and streamers permissions" do
      post :grant, twitter_id: @user.twitter_id, permissions: {gmod: 1, streamer: 1}
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["twitter_id"]).to eq(@user.twitter_id)
      expect(@user.gmod).to eq(0)
      expect(User.find(@user.id).gmod).to eq(1)
    end
    it "should return error with invalid id" do
      post :grant, twitter_id: "000", permissions: {gmod: 1, streamer: 1}
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json["message"]).to eq("User is not found")
    end
  end
end
