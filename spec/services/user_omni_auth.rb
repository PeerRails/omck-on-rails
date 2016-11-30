require 'rails_helper'

RSpec.describe UserOmniAuth do

  describe "authorize" do

    let(:twitter){OmniAuth.config.mock_auth[:twitter]}
    it "should login with twitter" do
      omniauth = UserOmniAuth.new(TwitterOmniAuth.new)
      expect(omniauth.authorize(twitter).persisted?).to be true 
    end


  end
end

