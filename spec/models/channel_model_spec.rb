require 'rails_helper'

RSpec.describe Channel, type: :model do
  before do
    @hdgames = create(:channel, :hdchannel, live: true)
    @twitch = create(:channel, :twitchchannel)
  end

  it "should show live channels" do
    expect(Channel.live.first).to eq(@hdgames)
  end

  it "should show non-live channels" do
    expect(Channel.not_live.first).to eq(@twitch)
  end

  it "should show official channels" do
    expect(Channel.official.first).to eq(@hdgames)
  end

  it "should show twitch channels" do
    expect(Channel.twitch.first).to eq(@twitch)
  end

  it "should show hd channels" do
    expect(Channel.hd.first).to eq(@hdgames)
  end

  it "should validate uniqueness of channel on service" do
    expect{create(:channel, :hdchannel)}.to raise_error(ActiveRecord::RecordInvalid) 
  end

  #it "should update info" do
   # account = Fabricate(:account)
    #account.update_info(@omni)
    #expect(@account.uid).to eq(9999)
  #end

end
