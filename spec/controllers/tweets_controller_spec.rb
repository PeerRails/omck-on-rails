require 'rails_helper'

RSpec.describe TweetsController, type: :controller do
  describe "GET #tweet" do
    before do
      @user = create(:user, :streamer)
      request.env["HTTP_ACCEPT"] = 'application/json'
      sign_in @user
      stub_request(:post, "https://api.twitter.com/1.1/statuses/update.json").
         with(:body => {"status"=>"text"},
              :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'TwitterRubyGem/5.15.0'}).
         to_return(:status => 200, :body => '{
           "created_at": "Wed Sep 05 00:37:15 +0000 2012",
           "id_str": "243145735212777472",
           "text": "text",
           "id": 243145735212777472
         }', :headers => {})
      stub_request(:post, "https://api.twitter.com/1.1/statuses/update.json").
         with(:body => {"status"=>"Стрим на #omcktv || text"},
              :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'TwitterRubyGem/5.15.0'}).
         to_return(:status => 200, :body => '{
           "created_at": "Wed Sep 05 00:37:15 +0000 2012",
           "id_str": "243145735212777472",
           "text": "Стрим на #omcktv || text",
           "id": 243145735212777472
         }', :headers => {})
    end
    it "should not update tweet without auth" do
      sign_out @user
      post :tweet, tweet: {comment: "text", own: 0}
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
    end
    it "should update tweet without own" do
      post :tweet, tweet: {comment: "text", own: 1}
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["text"]).to eq("text")
      expect(json["user"]).to eq(@user.name)
    end
    it "should update tweet without own" do
      post :tweet, tweet: {comment: "text", own: 0}
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["text"]).to eq("Стрим на #omcktv || text")
      expect(json["user"]).to eq(@user.name)
    end
  end
end
