require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before do
    @streamer = create(:user, :streamer)
    sign_in @streamer
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe "GET #list" do
    it "should list all users" do
      get :list
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["users"].count).to eq(1)
    end
  end

  describe "GET #show" do
    it "should list required user" do
      get :show, id: @streamer.id
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["user"]["twitter_id"]).to eq(@streamer.twitter_id)
    end
  end

  describe "GET #videos" do
    it "should list users videos" do
      create(:video, user_id: @streamer.id, key_id: @streamer.keys.last.id)
      get :videos, id: @streamer.id
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["videos"][0]["user_id"]).to eq(@streamer.id)
    end
  end

  describe "POST #update" do
    it "should update user data" do
      post :update, {id: @streamer.id, user: {screen_name: "new", name: "ahhaha", profile_image_url: "http://google.com/jpg.jpg"}}
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["user"]["id"]).to eq(@streamer.id)
      expect(json["user"]["screen_name"]).to eq("new")
    end
  end

  describe "POST #grant" do
    it "should grant user permissions" do
      post :grant, {id: @streamer.id, user: {streamer: 0, gmod: 1}}
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["user"]["id"]).to eq(@streamer.id)
      expect(json["user"]["streamer"]).to eq(0)
    end
  end

  describe "POST #invite" do
    before do
      request.env["HTTP_ACCEPT"] = 'application/json'
      stub_request(:get, "https://api.twitter.com/1.1/users/show.json?screen_name=@omckws&skip_status=true").
         to_return(:status => 200, :body => '{
           "created_at": "Sat Dec 14 04:35:55 +0000 2013",
           "id": 2244994945,
           "id_str": "2244994945",
           "name": "omckws",
           "screen_name": "omckws"
         }', :headers => {})
    end
    it "should invite new user by twitter username" do
      post :invite, user: {screen_name: "@omckws"}
      json = JSON.parse(response.body)
      user = User.last
      expect(json["error"]).to be nil
      expect(json["user"]["id"]).to eq(user.id)
      expect(json["user"]["screen_name"]).to eq("omckws")
    end
  end

end
