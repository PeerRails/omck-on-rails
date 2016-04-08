require 'rails_helper'

RSpec.describe Api::V1::VideosController, type: :controller do
  before do
    @streamer = create(:user, :streamer)
    sign_in @streamer
    create(:video, user_id: @streamer.id, key_id: @streamer.keys.present.last.id)
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe "GET #videos" do
    it "should list undeleted videos" do
      get :list
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["videos"].count).not_to eq(0)
    end

    it "should list all deleted videos" do
      get :list, status: "deleted"
      create(:video, user_id: @streamer.id, key_id: @streamer.keys.present.last.id, deleted: true, token: "deletededede")
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["videos"].count).not_to eq(0)
      expect(json["videos"][0]["deleted"]).to be true
    end
  end

end
