require 'rails_helper'

RSpec.describe Stream, type: :model do
  let(:user) {build(:user, :streamer, id: 1)}
  let(:key) {build(:key, user_id: 1, id: 1)}
  let(:channel) {build(:channel, :hdchannel, id: 1)}

  describe "associates with" do
    before do
      @stream = create(:stream, user_id: user.id, key_id: key.id, channel_id: channel.id)
    end

    it { expect(key.streams.last).to eq(@stream) }
    it { expect(user.streams.last).to eq(@stream) }
    it { expect(channel.streams.last).to eq(@stream) }
  end

  describe "validates" do
    before do
      @stream = create(:stream, user_id: user.id, key_id: key.id, channel_id: channel.id, ended_at: DateTime.now)
    end
    let(:stream_factory) { create(:stream, user_id: user.id, key_id: key.id, channel_id: channel.id) }

    it { expect(create(:stream, user_id: user.id, key_id: key.id, channel_id: channel.id).ended_at).to be nil }
    it { expect(@stream.stop!(DateTime.now)).to be false }
    it {
      @stream.update(ended_at: nil)
      expect(@stream.stop!(DateTime.now)).to be true
    }

    it { expect(stream_factory).to validate_presence_of(:key_id) }
    it { expect(stream_factory).to validate_presence_of(:user_id) }
    it { expect(stream_factory).to validate_presence_of(:channel_id) }

  end
end
