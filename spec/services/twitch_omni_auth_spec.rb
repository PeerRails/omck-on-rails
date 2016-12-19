require 'rails_helper'

RSpec.describe TwitchOmniAuth do

  describe "update" do

    let(:twitch){OmniAuth.config.mock_auth[:twitch]}
    it "should update account" do
      twitch_auth = TwitchOmniAuth.new
      twitch_auth.omniauth = twitch
      account = create(:account, client: create(:client))
      expect(twitch_auth.update(account)).to be true
    end


  end
end

