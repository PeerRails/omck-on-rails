require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  describe "get #list" do
    before  do
      request.env["HTTP_ACCEPT"] = 'application/json'
    end
    it "should return list of videos" do
      user = create(:user)
      video = create(:video, user_id: user.id, key_id: user.keys.last.id)
      get :list
      json = JSON.parse(response.body)["videos"]
      expect(json.length).to eq(1)
      expect(json[0]["token"]).to eq(video.token)
    end
    it "should return list of user videos" do
      user = create(:user)
      create(:video, user_id: user.id)
      get :list, video: {user_id: user.id}
      json = JSON.parse(response.body)["videos"]
      expect(json.length).to eq(1)
      expect(json[0]["token"]).to eq(user.videos.last.token)
    end
    it "should return empty list with incorrect id" do
      user = create(:user)
      create(:video, user_id: user.id, key_id: user.keys.last.id)
      get :list, video: {user_id: 0}
      json = JSON.parse(response.body)["videos"]
      expect(json.length).to eq(0)
    end
  end
  describe "delete  #remove" do
    before  do
      request.env["HTTP_ACCEPT"] = 'application/json'
      @user = create(:user, :streamer)
      sign_in @user
    end
    it "should mark record as deleted" do
      video = create(:video)
      delete :remove, tag_tokens: [video.token]
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
    end
    it "should not mark record as deleted with incorrect params" do
      video = create(:video)
      delete :remove, tag_tokens: nil
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json["message"]).to eq("Invalid tokens")
    end
    it "should not mark record as deleted with incorrect tokens" do
      video = create(:video)
      delete :remove, tag_tokens: [nil, "nil"]
      json = JSON.parse(response.body)
      expect(json["videos"][0]["error"]).to be true
      expect(json["videos"][0]["message"]).to eq("Required file not found")
      expect(json["videos"][1]["error"]).to be true
      expect(json["videos"][1]["message"]).to eq("Required file not found")
    end
  end
end
