require 'rails_helper'

RSpec.describe TweetsController, type: :controller do
  describe "GET #tweet" do
    before do
      request.env["HTTP_ACCEPT"] = 'application/json'
    end
    it "should not update tweet without auth" do
      user = create(:user)
      tweet = build(:tweet, user_id: user)
      get :tweet
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
    end
  end
end
