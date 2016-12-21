require 'rails_helper'

RSpec.describe ChannelOperator do
  describe "#get_channel" do
      it "should get channel" do
        channel = create(:channel)
        response = ChannelOperator.get_channel({ service: channel.service, channel: channel.channel })
        expect(response.success?).to be true
        expect(response.data.class).to be Channel
      end

      it "should get channels by service name" do
        channel = create(:channel)
        response = ChannelOperator.get_service( channel.service )
        expect( response.success? ).to be true
        expect( response.data.count ).to eq(1)
      end

      it "should return error" do
        response = ChannelOperator.get_channel({ service: "", channel: "" })
        expect(response.success?).to be false
        expect(response.error?).to be true
      end
  end

  describe "#show" do
    it "should route to get_channel" do
      channel = create(:channel)
      response = ChannelOperator.show({ service: channel.service, channel: channel.channel })
      expect( response.data.class).to be Channel
    end

    it "should route to get_service" do
      channel = create(:channel)
      response = ChannelOperator.show({ service: channel.service })
      expect( response.data.count ).to eq(1)
    end
  end

  describe "#create" do
    it "should create new channel" do
      channel = {channel: "johndoe", service: "janedoe"}
      response = ChannelOperator.create(channel)
      expect(response.success?).to be true
      expect(response.data.channel).to eql("johndoe")
    end

    it "should return error" do
      channel = create(:channel)
      response = ChannelOperator.create({ channel: channel.channel, service: channel.service })
      expect(response.error?).to be true
      expect(response.success?).to be false
    end
  end

  describe "#update" do
    it "should update channel" do
      channel = create(:channel)
      response = ChannelOperator.update({service: channel.service, channel: channel.channel, data: { live: true } })
      expect( response.success? ).to be true
      expect( response.error? ).to be nil
      expect( response.data.live ).to be true
    end

    it "should show error" do
      response = ChannelOperator.update({ service: "", channel: "", data: { live: true } })
      expect(response.success?).to be false
      expect(response.error?).to be true
    end
  end

  describe "#switch" do
    it "should change live status of channel" do
      channel = create(:channel, live: true)
      response = ChannelOperator.switch({ service: channel.service, channel: channel.channel})
      expect(response.success?).to be true
      expect(response.data.live).to be false
    end

    it "should show error" do
      response = ChannelOperator.switch({ service: "", channel: "" })
      expect(response.success?).to be false
      expect(response.error?).to be true
    end
  end

  describe "#destroy" do
    it "should delete channel" do
      channel = create(:channel)
      response = ChannelOperator.destroy({ service: channel.service, channel: channel.channel })
      expect(response.success?).to be true
      expect(Channel.where(id: response.data.id).count).to eq(0)
    end

    it "should show error" do
      response = ChannelOperator.destroy({ service: "", channel: "" })
      expect( response.success? ).to be false
      expect( response.error? ).to be true
      expect( response.data.status ).to be 400
    end
  end

end
