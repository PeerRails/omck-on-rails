require 'rails_helper'

RSpec.describe TwitterOmniAuth do

  describe "update" do

    let(:twitter){OmniAuth.config.mock_auth[:twitter]}
    it "should update account" do
      twitter_auth = TwitterOmniAuth.new
      twitter_auth.omniauth = twitter 
      account = create(:account, client: create(:client)) 
      expect(twitter_auth.update(account)).to be true 
    end


  end
end

