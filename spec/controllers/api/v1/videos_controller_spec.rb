require 'rails_helper'

RSpec.describe Api::V1::VideosController, type: :controller do
  before do
    @streamer = create(:user, :streamer)
    @token = create(:api_token, user_id: @streamer.id)
    request.headers["HTTP_API_TOKEN"] = @token.secret
    @video = create(:video, user_id: @streamer.id, key_id: @streamer.keys.present.last.id, path: "/home/user/videos/123.flv")
    request.env["HTTP_ACCEPT"] = 'application/json'
  end
  let(:clear_headers) {request.headers["HTTP_API_TOKEN"] = nil}

  describe "GET #videos" do
    it "should list undeleted videos" do
      get :list
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["videos"].count).not_to eq(0)
    end

    it "should list all deleted videos" do
      create(:video, user_id: @streamer.id, key_id: @streamer.keys.present.last.id, token: "deletededede", deleted: true)
      get :list, deleted: "true"
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["videos"].count).not_to eq(0)
      expect(json["videos"][0]["deleted"]).to be true
    end

    it "should list all unarchived videos" do
      create(:video, user_id: @streamer.id, key_id: @streamer.keys.present.last.id, token: "deletededede", deleted: false)
      get :list, deleted: "false"
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["videos"].count).not_to eq(0)
      expect(json["videos"][0]["deleted"]).to be false
    end

  end

  describe "GET #show" do
    it "should show video by token param" do
      get :show, token: @video.token
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["video"]["token"]).to eq(@video.token)
    end
  end

  describe "POST #add" do
    it "should add new video" do
      post :add, {video: {path: "/home/user/videos/test.flv", user_id: @streamer.id, key_id: @streamer.keys.present.last.id, deleted: false, game: @streamer.keys.present.last.game, description: "#{@streamer.keys.present.last.game} by #{@streamer.name} #{DateTime.now.strftime("%Y%m%d%H%M%S")}"}}
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["video"]["key_id"]).to eq(@streamer.keys.present.last.id)
    end
  end

  describe "POST #update" do
    it "should update video video" do
      video = create(:video, user_id: @streamer.id, key_id: @streamer.keys.present.last.id, deleted: false, game: @streamer.keys.present.last.game, description: "#{@streamer.keys.present.last.game} by #{@streamer.name} #{DateTime.now.strftime("%Y%m%d%H%M%S")}")
      post :update, {token: video.token, video: {deleted: true}}
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["video"]["token"]).to eq(video.token)
      expect(json["video"]["deleted"]).to be true
    end
  end

  describe "DELETE #archive" do
    it "should update video" do
      video = create(:video, user_id: @streamer.id, key_id: @streamer.keys.present.last.id, deleted: false, game: @streamer.keys.present.last.game, description: "#{@streamer.keys.present.last.game} by #{@streamer.name} #{DateTime.now.strftime("%Y%m%d%H%M%S")}")
      delete :archive, {token: video.token}
      json = JSON.parse(response.body)
      expect(json["error"]).to be false
      expect(json["message"]).to eq("Archived!")
    end

    it "shouldnt delete video if unathorized" do
      video = create(:video, user_id: @streamer.id, key_id: @streamer.keys.present.last.id, deleted: false, game: @streamer.keys.present.last.game, description: "#{@streamer.keys.present.last.game} by #{@streamer.name} #{DateTime.now.strftime("%Y%m%d%H%M%S")}")
      clear_headers
      delete :archive, {token: video.token}
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json["message"]).to eq("Access Denied")
    end
  end

  describe "GET #path" do
    before do
      @streamer.update(gmod: 1)
      @video.update(deleted: true)
    end

    it "should show video path by token param" do
      get :path, token: @video.token
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["token"]).to eq(@video.token)
      expect(json["path"]).to eq(@video.path)
    end

    it "should show error if token incorrect" do
      get :path, token: "123456"
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json["message"]).to eq("Not Found")
    end
  end

end
