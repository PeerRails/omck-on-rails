require 'rails_helper'

RSpec.describe TweetsController, type: :controller do
  describe "GET #tweet" do
    before do
      @user = create(:user, :streamer)
      request.env["HTTP_ACCEPT"] = 'application/json'
      sign_in @user
    end
    it "should not update tweet without auth" do
      sign_out @user
      post :tweet, tweet: {comment: "text"}
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
    end

    it "should show last tweets" do
      create(:tweet, comment: "Hello twitter!", user_id: @user.id)
      get :list
      json = JSON.parse(response.body)
      expect(json['error']).to be nil
      expect(json['tweets'].last['user']['id']).to eq(@user.id)
    end

    let(:json_file) { File.new(File.expand_path('../../support/status.json', __FILE__)) }
    let(:json_file_with_link) { File.new(File.expand_path('../../../../support/status_with_link.json', __FILE__)) }
    let(:bitly_response) { File.new(File.expand_path('../../../../support/bitly.json', __FILE__)) }

    it "should update tweet" do
      stub_request(:post, "https://api.twitter.com/1.1/statuses/update.json").
        with(:body => {"status"=>"text"}, :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'TwitterRubyGem/5.16.0'}).
         to_return(:status => 200, :body => json_file, :headers => {})
      post :tweet, tweet: {comment: "text"}
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["tweet"]["comment"]).to eq("text")
      expect(json["tweet"]["user"]["id"]).to eq(@user.id)
    end

    #it "should update tweet with link" do
    #  stub_request(:post, "https://api.twitter.com/1.1/statuses/update.json").
    #    with(:body => {"status"=>"text"}, :headers => {'Accept'=>'application/json', #'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'TwitterRubyGem/5.16.0'}).
    #     to_return(:status => 200, :body => json_file, :headers => {})
    #  stub_request(:get, "http://api.bitly.com/v3/shorten?apiKey=bt&login=bu&longUrl=http://omck.tv").
    #     with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
    #     to_return(:status => 200, :body => bitly_response, :headers => {})
    #  post :tweet, tweet: {comment: "text http://omck.tv"}
    #  json = JSON.parse(response.body)
    #  expect(json["error"]).to be nil
    #  expect(json["tweet"]["comment"]).to eq("text")
    #  expect(json["tweet"]["user"]["id"]).to eq(@user.id)
    #end
  end
end
