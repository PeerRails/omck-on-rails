require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  describe "get #list" do
    it "should return list of videos" do
      user = create(:user)
      create(:key, user_id: user.id)
      video = create(:video, user_id: user.id, key_id: user.keys.last.id)
      get :list
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json[0]["token"]).to eq(video.token)
    end
    it "should return list of user videos" do
      user = create(:user)
      create(:key, user_id: user.id)
      create(:video, user_id: user.id, key_id: user.keys.last.id)
      get :list, video: {user_id: user.id}
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json[0]["token"]).to eq(user.videos.last.token)
    end
    it "should return empty list with incorrect id" do
      user = create(:user)
      create(:key, user_id: user.id)
      create(:video, user_id: user.id, key_id: user.keys.last.id)
      get :list, video: {user_id: 0}
      json = JSON.parse(response.body)
      expect(json.length).to eq(0)
    end
  end
  describe "delete  #remove" do
    it "should mark record as deleted" do
      video = create(:video)
      delete :remove, tag_tokens: [video.token]
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil

    end
  end
end
