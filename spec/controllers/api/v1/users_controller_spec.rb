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
      get :show, twitter_id: @streamer.twitter_id
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["user"]["twitter_id"]).to eq(@streamer.twitter_id)
    end
  end

end
