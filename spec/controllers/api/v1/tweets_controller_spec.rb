require 'rails_helper'

RSpec.describe Api::V1::TweetsController, type: :controller do
  before do
    @streamer = create(:user, :streamer)
    sign_in @streamer
    #@video = create(:video, user_id: @streamer.id, key_id: @streamer.keys.present.last.id)
    @tweet = create(:tweet, own: 0, comment: "Wow", user_id: @streamer.id)
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe "GET #list" do
    it "should list tweets" do
      get :list
      json = JSON.parse(response.body)
      expect(json["tweets"].count).to eq(1)
    end

    # TODO add pagination
    #it "should paginate tweets" do
    #  20.times do
    #    create(:tweet, own: 0, comment: "Wow", user_id: @streamer.id)
    #  end
    #  get :list, page: 2
    #  json = JSON.parse(response.body)
    #  expect(json["tweets"].count).to eq(1)
    #end
  end

  describe "GET #show" do
    it "should show tweet by id param" do
      get :show, id: @tweet.id
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["tweet"]["id"]).to eq(@tweet.id)
    end
  end

  describe "GET #by_user" do
    it "should show tweet by user id param" do
      get :show, id: @streamer.id
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      #expect(json["tweets"][0]["author"]).to eq(@streamer.name)
    end
  end

end
