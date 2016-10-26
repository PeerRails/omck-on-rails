# == Schema Information
#
# Table name: keys
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  key        :string(255)      not null
#  game       :string(255)      default("Boku no Pico"), not null
#  expires    :datetime         default(Thu, 01 Jan 2099 00:00:00 UTC +00:00), not null
#  streamer   :string(255)      default("McDwarf")
#  created_at :datetime
#  updated_at :datetime
#  guest      :boolean          default(FALSE)
#  movie      :string(255)      default("Boku Wa Tomodachi Ga Sekai")
#  created_by :integer
#  client_id  :integer
#

require 'rails_helper'

RSpec.describe Key, type: :model do
    describe "associations" do

        it { should belong_to(:client) }
        it { should have_many(:videos) }
        it { should have_many(:streams) }

    end

    describe "validations" do
        it { should validate_presence_of(:streamer) }
        it { should validate_presence_of(:client_id).on(:create) }
        it { should validate_uniqueness_of(:client_id)}
        it { should validate_uniqueness_of(:key) }

        it { should validate_length_of(:streamer).is_at_least(3).is_at_most(40) }
        it { should validate_length_of(:game).is_at_least(3).is_at_most(40) }
        it { should validate_length_of(:movie).is_at_least(3).is_at_most(40) }

        it "should create new key for every new client" do
            expect{create(:client, :streamer)}.to change{Key.count}.by(1)
        end
    end

    describe "actions" do
        it "should regenerate on request" do
            key = create(:client).key
            key.regenerate!
            new_key = Key.find(key.id)
            expect( key.id ).to eq(new_key.id)
            expect( key.expires ).not_to eq(new_key.expires)
        end
    end
end
