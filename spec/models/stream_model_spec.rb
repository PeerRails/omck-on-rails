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

    it { expect(@stream.stop!(DateTime.now).errors).not_to be nil }
  end
end
