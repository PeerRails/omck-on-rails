require 'rails_helper'

RSpec.describe Channel, type: :model do
  describe "validates" do
      it { should validate_presence_of(:channel) }
      it { should validate_presence_of(:streamer) }
      it { should validate_uniqueness_of(:channel).scoped_to(:service) }
      it { should allow_value('twitch').for(:channel)}
      it { should_not allow_value('t*witch').for(:channel)}

  end
end
