require 'rails_helper'

RSpec.describe ChannelsController, type: :controller do
  before do
    @hdgames = create(:channel, :hdchannel)
    @twitch = create(:channel, :twitchchannel)
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe 'serialize' do
    it 'returns valid serialized channel' do
      valid = { 'channel' => 'hdgames',
                'viewers' => 0,
                'live' => false,
                'game' => 'Boku no Pico',
                'title' => 'Title',
                'streamer' => 'McDwarf',
                'service' => 'hd',
                'official' => true,
                'error' => nil }
      expect(ChannelsController.new.send(:serialize, @hdgames)).to eq(valid)
    end
  end

  describe 'GET #list_all' do
    it 'returns list of all channels' do
      get :list_all
      json = JSON.parse(response.body)
      expect(json.count).to eq(2)
    end
  end

  describe 'GET #list_live' do
    before do
      @omcktv = create(:channel, service: 'twitch', channel: 'omcktv', official: true, live: false)
    end

    it 'returns empty list' do
      get :list_live
      json = JSON.parse(response.body)
      expect(json[0]).to eq(nil)
    end
    it 'returns list with live channel' do
      @omcktv.live = true
      @omcktv.save
      get :list_live
      json = JSON.parse(response.body)
      expect(json[0]['channel']).to eq('omcktv')
    end
  end

  #   describe "service" do
  #     before do
  #       create(:channel, :hdchannel, channel: "hdcinema")
  #       create(:channel, :hdchannel, channel: "records")
  #     end
  #     it "returns list of service channels" do
  #       get :service_list
  #       json = JSON.parse(response.body)
  #       expect(json.count).to eq(3)
  #     end
  #   end

  describe 'GET #show' do
    it 'returns hdgames' do
      get :show, service: 'hd', channel: 'hdgames'
      json = JSON.parse(response.body)
      expect(json['channel']).to eq('hdgames')
    end
    it 'return error' do
      get :show, service: '3ds', channel: 'homebrew'
      json = JSON.parse(response.body)
      expect(json['error']).to eq(true)
    end
  end

  describe 'action without authorization' do
    it 'should not create new channel' do
      post :create, channels: {service: 'twitch', channel: 'blizzheroes', streamer: 'host'}
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']).to eq('You dont have access to this action')
    end
    it 'should not update channel' do
      post :update, channels: {service: 'hd', channel: 'hdgames', streamer: 'Veli'}
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']).to eq('You dont have access to this action')
    end
  end

  describe 'POST #create' do
    before do
      @streamer = create(:user, :streamer)
      sign_in @streamer
    end
    it 'should create new channel' do
      post :create, channels: {service: 'twitch', channel: 'blizzheroes', streamer: 'hots'}
      json = JSON.parse(response.body)
      expect(json['channel']).to eq('blizzheroes')
    end

    it 'returns duplicate error' do
      create(:channel, service: 'twitch', channel: 'blizzheroes', streamer: 'hots')
      post :create, channels: {service: 'twitch', channel: 'blizzheroes', streamer: 'hots'}
      json = JSON.parse(response.body)
      expect(json['error']).to eq(true)
    end

    it 'return invalid data error' do
      post :create
      json = JSON.parse(response.body)
      expect(json['error']).to eq(true)
    end

    it 'return invalid channel name error' do
      post :create, channels: {service: 'twitch', channel: 'хардкод'}
      json = JSON.parse(response.body)
      expect(json['error']).to eq(true)
    end
  end

  describe 'PUT #update' do
    before do
      @streamer = create(:user, :streamer)
      sign_in @streamer
    end
    it 'returns updated channel' do
      put :update, channels: {service: 'hd', channel: 'hdgames', streamer: 'Veli'}
      json = JSON.parse(response.body)
      expect(json['streamer']).to eq('Veli')
    end
    it 'returns not found error' do
      put :update, channels: {service: 'hd', channel: 'hdcinema', streamer: 'Veli'}
      json = JSON.parse(response.body)
      expect(json['error']).to eq(true)
    end
    it 'returns invalid channel name error' do
      put :update, channels: {service: 'hd', channel: 'hdgames', streamer: ''}
      json = JSON.parse(response.body)
      expect(json['error']).to eq(true)
    end
  end
  
  describe "DELETE #remove" do
    before do
      @streamer = create(:user, :streamer)
      create(:channel, service: 'twitch', channel: 'velikun', streamer: 'Veli')
      sign_in @streamer
    end
    it 'deletes channel' do
      delete :remove, channels: {service: 'twitch', channel: 'velikun'}
      json = JSON.parse(response.body)
      expect(json['error']).to be nil
    end
  end
  #   describe "#bitdash" do
  #     it "return success" do
  #       get :bitdash
  #       expect(response).to have_http_status(:success)
  #     end
  #   end
end
