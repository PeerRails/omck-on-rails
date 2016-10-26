require 'rails_helper'

RSpec.describe Stream, type: :model do
  describe "associations" do
      it { should belong_to(:key)}
      it { should belong_to(:client)}
      it { should belong_to(:channel)}

      it { should validate_presence_of(:key_id)}
      it { should validate_presence_of(:client_id)}
      it { should validate_presence_of(:channel_id)}
  end

  describe "actions" do
      it "should mark the time the stream stopped" do
          stream = build(:stream)
          expect(stream.stop!).to be true
      end
  end
end
