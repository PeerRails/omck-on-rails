require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #show" do
    before do
      @user = create(:user, :streamer)
      sign_in @user
      request.env["HTTP_ACCEPT"] = 'application/json'
    end
    it "should show user information" do
      get :show, id: @user.id
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json['user']["twitter_id"]).to eq(@user.twitter_id)
    end
    it "should return error with incorrect id" do
      get :show, id: "0000"
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json["message"]).to eq("Record not Found")
    end
  end
  describe "get #videos" do
    before do
      @user = create(:user, :streamer)
      sign_in @user
      request.env["HTTP_ACCEPT"] = 'application/json'
    end
    it "should return list of videos" do
      vid = create(:video, user_id: @user.id, key_id: @user.keys.last.id)
      get :videos, id: @user.id
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["videos"][0]["token"]).to eq(vid.token)
    end
    it "should return error with incorrect user" do
      create(:video, user_id: @user.id)
      get :videos, id: @user.id+10
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json["message"]).to eq("Record not Found")
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
      post :grant, {id: @user.id, user: {streamer: 1}}
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json['user']["twitter_id"]).to eq(@user.twitter_id)
    end
    it "should grant mod permission" do
      post :grant, {id: @user.id, user: {gmod: 1}}
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json['user']["twitter_id"]).to eq(@user.twitter_id)
    end
    it "should grant both mod and streamers permissions" do
      post :grant, {id: @user.id, user: {streamer: 1, gmod: 1}}
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json['user']["twitter_id"]).to eq(@user.twitter_id)
    end
    it "should return error with invalid id" do
      post :grant, {id: "1024", user: {streamer: 1, gmod: 1}}
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json["message"]).to eq("Record not Found")
    end
  end
  describe "GET #list" do
    before do
      @user = create(:user)
      @streamer = create(:user, :mod)
      sign_in @streamer
      request.env["HTTP_ACCEPT"] = 'application/json'
    end
    it "should list all users to admin" do
      get :list
      json = JSON.parse(response.body)
      expect(json["users"].length).to eq(User.count)
    end
  end
  describe 'POST #invite' do
    before do
      @mod = create(:user, :mod)
      @user = create(:user, :streamer)
      sign_in @mod
      request.env["HTTP_ACCEPT"] = 'application/json'
      stub_request(:get, "https://api.twitter.com/1.1/users/show.json?screen_name=@TwitterDev&skip_status=true").
         to_return(:status => 200, :body => '{
           "created_at": "Sat Dec 14 04:35:55 +0000 2013",
           "id": 2244994945,
           "id_str": "2244994945",
           "name": "TwitterDev",
           "screen_name": "TwitterDev"
         }', :headers => {})
      stub_request(:get, "https://api.twitter.com/1.1/users/show.json?screen_name=@#{@user.screen_name}&skip_status=true").
        to_return(:status => 200, :body => "{
          \"created_at\": \"Sat Dec 14 04:35:55 +0000 2013\",
          \"id\": #{@user.twitter_id},
          \"id_str\": \"#{@user.twitter_id}\",
          \"name\": \"#{@user.name}\",
          \"screen_name\": \"#{@user.screen_name}\"
        }", :headers => {})
      stub_request(:get, "https://api.twitter.com/1.1/users/show.json?screen_name=@#{@mod.screen_name}&skip_status=true").
        to_return(:status => 200, :body => "{
          \"created_at\": \"Sat Dec 14 04:35:55 +0000 2013\",
          \"id\": #{@mod.twitter_id},
          \"id_str\": \"#{@mod.twitter_id}\",
          \"name\": \"#{@mod.name}\",
          \"screen_name\": \"#{@mod.screen_name}\"
        }", :headers => {})
    end
    it 'should invite twitter user' do
      post :invite, user: {screen_name: "@TwitterDev"}
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json['user']["twitter_id"]).to eq("2244994945")
    end
    it 'should not invite user if not streamer or admin' do
      @mod.update(streamer: 0, gmod: 0)
      post :invite, user: {screen_name: "@TwitterDev"}
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json["message"]).to eq("You dont have access to this action")
    end
    it 'should grant permission to existing user' do
      User.update(@user.id, streamer: 0)
      post :invite, user: {screen_name: "@#{@user.screen_name}"}
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json['user']["twitter_id"]).to eq(@user.twitter_id)
      expect(json['user']["streamer"]).to be true
    end
    #it 'should not grant permission to self' do
    #  User.update(@mod.id, streamer: 0)
    #  post :invite, user: {screen_name: "@#{@mod.screen_name}"}
    #  json = JSON.parse(response.body)
    #  expect(json["error"]).to be true
    #  expect(json["message"]).to eq("You dont have access to this action")
    #end
  end
end
