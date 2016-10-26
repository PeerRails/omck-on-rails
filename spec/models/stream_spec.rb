# == Schema Information
#
# Table name: streams
#
#  id         :integer          not null, primary key
#  key_id     :integer          not null
#  user_id    :integer          not null
#  channel_id :integer          not null
#  game       :string
#  movie      :string
#  streamer   :string
#  ended_at   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :integer
#

require 'rails_helper'

RSpec.describe Stream, type: :model do
  describe "associations" do
      it { should belong_to(:key)}
      it { should belong_to(:client)}
      it { should belong_to(:channel)}
      it { should have_one(:video)}
      
      it { should validate_presence_of(:key_id)}
      it { should validate_presence_of(:client_id)}
      it { should validate_presence_of(:channel_id)}
  end

  describe "actions" do
      it "should mark the time the stream stopped" do
          stream = build(:stream)
          expect(stream.stop!).to be true
      end

      it "should return false if stream was already marked" do
          stream = build(:stream, ended_at: DateTime.now)
          expect(stream.stop!).to be false
      end
  end
end
