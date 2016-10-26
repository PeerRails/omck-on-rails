# == Schema Information
#
# Table name: videos
#
#  id          :integer          not null, primary key
#  game        :string           default("Boku no Pico"), not null
#  user_id     :integer
#  key_id      :integer
#  youtube_id  :string
#  description :text             default("Boku no Pico")
#  token       :string           not null
#  path        :string
#  deleted     :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  client_id   :integer
#  stream_id   :integer
#

require 'rails_helper'

RSpec.describe Video, type: :model do
  describe "associations" do
      it { should belong_to(:client)}
      it { should belong_to(:stream)}
      it { should belong_to(:key)}
  end

  describe "actions" do
      it "should attach token before creation" do
          video = build(:video, token: nil, client_id: 1, stream_id: 1, key_id: 1)
          video.save
          expect(video.token).not_to be nil
      end
  end
end
