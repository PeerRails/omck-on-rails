require 'rails_helper'

RSpec.describe Api::V1::KeysController, type: :controller do
  before do
    @streamer = create(:user, :streamer)
    @key = @streamer.keys.present.last
    @gkey = create(:key, guest: true, created_by: @streamer.id, user_id: @streamer.id)
    sign_in @streamer
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe "GET #retrive" do
    it "should show user key" do
      get :retrieve
      json = JSON.parse(response.body)["key"]
      expect(json["user_id"]).to eq(@streamer.id)
    end
  end

  describe "GET #all" do
    it 'should list all keys to gmod' do
      get :all
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
    end
  end

  describe "GET #guest" do
    it 'should list guest keys to gmod' do
      get :guest
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
    end
  end

  describe "POST #create" do
    it "should create new key for user" do
      user = create(:user)
      user.keys.present.last.expire
      post :create, key: {user_id: user.id, guest: false}
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(Key.where(user_id: user.id).count).to eq(2)
    end
  end

  describe "POST #regenerate" do
    it "should expire old key, create and give back new key" do
      user = create(:user)
      old_key = user.keys.present.last.key
      post :regenerate, key: {user_id: user.id}
      expect(user.keys.present.last.key).not_to eq(old_key)
    end
  end

end
