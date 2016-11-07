# == Schema Information
#
# Table name: channels
#
#  id         :integer          not null, primary key
#  channel    :string
#  live       :boolean          default(FALSE)
#  viewers    :integer          default(0), not null
#  game       :string           default("Boku no Pico"), not null
#  streamer   :string           default("McDwarf")
#  title      :string           default("Boku wa Tomodachi ga Sekai")
#  service    :string           default("twitch")
#  created_at :datetime
#  updated_at :datetime
#  official   :boolean          default(FALSE)
#

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
