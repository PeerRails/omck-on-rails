require 'rails_helper'

RSpec.describe ChannelsController, type: :controller do

  describe "#live" do
    before do
      create(:channel, live: true)
      get :live
    end
    let(:json){JSON.parse(response.body)}
    it { expect(json["error"]).to be nil }
  end

  describe "#all" do
    before do
      create(:channel)
      get :all
    end
    let(:json){JSON.parse(response.body)}
    it { expect(json["error"]).to be nil }
  end

  describe "#show" do
    before do
      create(:channel, service: 'twitch')
      create(:channel, channel: 'second', service: 'twitch')
    end
    let(:json){JSON.parse(response.body)}
    it "should show channel by service and channel names" do
      get :show, params: { service: 'twitch', channel: 'second' }
      expect(json['errors']).to be nil
      expect(json['channel']['channel']).to eq('second')
    end

    it "should show channels by service name" do
      get :show, params: { service: 'twitch' }
      expect( json['errors'] ).to be nil
      expect( json['channels'].count ).to eq(2)
    end
  end

  describe "#create" do
    let(:json){JSON.parse(response.body)}
    it "should create new channel" do
      post :create, params: { channel: { channel: 'second', service: 'twitch', streamer: 'vanya' } }
      expect( json['error'] ).to be nil
      expect( json['response']['channel'] ).to eq('second')
    end

    it "should show error if data incorrect" do
      create(:channel, channel: 'errorchannel', streamer: 'streamer')
      post :create, params: { channel: { channel: 'errorchannel', service: 'hd', streamer: 'streamer' } }
      expect( json['response']['channel'][0] ).to eql('has already been taken')
    end
  end

  describe "#update" do
    before do
      @channel = create(:channel)
    end
    let(:json){JSON.parse(response.body)}
    it "should update channel" do
      params = {
        viewers: 14
      }
      put :update, params: {channel: @channel.channel, service: @channel.service, data: params}
      expect( json['error'] ).to be nil
      expect( json['response']['viewers'] ).to eq(14)
    end

    it "should show error" do
      params = {
        channel: "123"
      }
      put :update, params: { channel: @channel.channel, service: "no", data: params }
      expect( json['error'] ).to be true
      expect( json['response'][0] ).to eql("not found")
    end
  end

  describe "#destroy" do

    before do
      @channel = create(:channel)
    end
    let(:json){JSON.parse(response.body)}
    it "should destroy channel" do
      delete :destroy, params: { service: @channel.service, channel: @channel.channel }
      expect( json['errors'] ).to be nil
      expect( json['message'] ).to eq('Channel deleted')
    end

    it "should show error" do
      delete :destroy, params: { service: 'vidya', channel: 'vudya' }
      expect( json['errors']['channel'][0] ).to eql("can't delete due to errors")
    end
  end

  describe "#switch" do
    let(:json){JSON.parse(response.body)}
    it "should switch status to live" do
      channel = create(:channel)
      get :switch, params: { service: channel.service, channel: channel.channel }
      expect( json['errors'] ).to be nil
      expect( json['channel']['live']).to be true
    end

    it "should show error" do
      get :switch, params: { service: 'se', channel: 'che' }
      expect( json['errors']['channel'][0] ).to eql("can't update due to errors")
    end
  end
end
