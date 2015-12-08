require 'rails_helper'

RSpec.describe ChannelsController, type: :controller do

  before do
    @hdgames = create(:channel, :hdchannel)
    @twitch = create(:channel, :twitchchannel)
  end

  describe "serialize" do
    it "returns valid serialized channel" do
      valid = {"channel" => "hdgames",
            "viewers" => 0,
            "live" => false,
            "game" => "Boku no Pico",
            "title" => "Title",
            "streamer" => "McDwarf",
            "service" => "hd",
            "official" => true,
            "error" => nil}
      expect(ChannelsController.new.send(:serialize, @hdgames)).to  eq(valid)
    end
  end

  describe "#list_all" do
    it "returns list of all channels" do
      get :list_all
      json = JSON.parse(response.body)
      expect(json.count).to eq(2)
    end
  end

  describe "#list_live" do
    before do
      @omcktv = create(:channel,service: 'twitch', channel: "omcktv", official: true, live: false)
    end

    it "returns empty list" do
      get :list_live
      json = JSON.parse(response.body)
      expect(json[0]).to eq(nil)
    end
    it "returns list with live channel" do
      @omcktv.live = true
      @omcktv.save
      get :list_live
      json = JSON.parse(response.body)
      expect(json[0]["channel"]).to eq("omcktv")
    end
  end

=begin
  describe "service" do
    before do
      create(:channel, :hdchannel, channel: "hdcinema")
      create(:channel, :hdchannel, channel: "records")
    end
    it "returns list of service channels" do
      get :service_list
      json = JSON.parse(response.body)
      expect(json.count).to eq(3)
    end
  end
=end

  describe "#show" do
    it "returns hdgames" do
      get :show, service: "hd", channel: "hdgames"
      json = JSON.parse(response.body)
      expect(json["channel"]).to eq("hdgames")
    end
    it "return error" do
      get :show, service: "3ds", channel: "homebrew"
      json = JSON.parse(response.body)
      expect(json["error"]).to eq(true)
    end
  end

  describe "#create" do
    it "creates new channel" do
      post :create, service: "twitch", channel: "blizzheroes", streamer: "hots"
      json = JSON.parse(response.body)
      expect(json["channel"]).to eq("blizzheroes")
    end

    it "returns duplicate error" do
      create(:channel, service: "twitch", channel: "blizzheroes", streamer: "hots")
      post :create, service: "twitch", channel: "blizzheroes", streamer: "hots"
      json = JSON.parse(response.body)
      expect(json["error"]).to eq(true)
    end

    it "return invalid data error" do
      post :create
      json = JSON.parse(response.body)
      expect(json["error"]).to eq(true)
    end

    it "return invalid channel name error" do
      post :create, service: "twitch", channel: "хардкод"
      json = JSON.parse(response.body)
      expect(json["error"]).to eq(true)
    end
  end

  describe "#update" do
    it "returns updated channel" do
      post :update, service: "hd", channel: "hdgames", streamer: "Veli"
      json = JSON.parse(response.body)
      expect(json["streamer"]).to eq("Veli")
    end
    it "returns not found error" do
      post :update, service: "hd", channel: "hdcinema", streamer: "Veli"
      json = JSON.parse(response.body)
      expect(json["error"]).to eq(true)
    end
    it "returns invalid channel name error" do
      post :update, service: "hd", channel: "hdgames", streamer: ""
      json = JSON.parse(response.body)
      expect(json["error"]).to eq(true)
    end
  end
=begin
  describe "#bitdash" do
    it "return success" do
      get :bitdash
      expect(response).to have_http_status(:success)
    end
  end
=end
end
