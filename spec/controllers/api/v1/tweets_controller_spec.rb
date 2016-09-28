require 'rails_helper'

RSpec.describe Api::V1::TweetsController, type: :controller do
  before do
    @streamer = create(:user, :streamer)
    @token = create(:api_token, user_id: @streamer.id)
    request.headers["HTTP_API_TOKEN"] = @token.secret
    #@video = create(:video, user_id: @streamer.id, key_id: @streamer.keys.present.last.id)
    @tweet = create(:tweet, comment: "Wow", user_id: @streamer.id)
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe "GET #list" do
    it "should list tweets" do
      get :list
      json = JSON.parse(response.body)
      expect(json["tweets"].count).to eq(1)
    end

    # TODO add pagination
    #it "should paginate tweets" do
    #  20.times do
    #    create(:tweet, own: 0, comment: "Wow", user_id: @streamer.id)
    #  end
    #  get :list, page: 2
    #  json = JSON.parse(response.body)
    #  expect(json["tweets"].count).to eq(1)
    #end
  end

  describe "GET #show" do
    it "should show tweet by id param" do
      get :show, id: @tweet.id
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["tweet"]["id"]).to eq(@tweet.id)
    end
  end

  describe "GET #by_user" do
    it "should show tweet by user id param" do
      get :by_user, user_id: @streamer.id
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["tweets"][0]["user"]["name"]).to eq(@streamer.name)
    end
  end

  #  Just a placeholder
  #describe "GET #timeline" do
    #it "should show tweet timeline" do
      #it shouldnt
    #end
  #end

  # webmock?
  let(:json_file) { File.new(File.expand_path('../../../../support/status.json', __FILE__)) }
  let(:json_file_with_link) { File.new(File.expand_path('../../../../support/status_with_link.json', __FILE__)) }
  let(:bitly_response) { File.new(File.expand_path('../../../../support/bitly.json', __FILE__)) }

  describe "POST #tweet" do
    it "should post tweet" do
      stub_request(:post, "https://api.twitter.com/1.1/statuses/update.json").with(:body => {"status"=>"text"}).to_return(:status => 200, :body => json_file)
      post :post, tweet: {comment: "text"}
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["tweet"]["comment"]).to eq("text")
      expect(json["tweet"]["user"]["id"]).to eq(@streamer.id)
    end

    #it "should post tweet with link" do
    #  stub_request(:post, "https://api.twitter.com/1.1/statuses/update.json").with(:body => {"status"=>"text"}).to_return(:status => 200, #:body => json_file_with_link)
    #  stub_request(:get, "http://api.bitly.com/v3/shorten?apiKey=bt&login=bu&longUrl=http://omck.tv").
    #     with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
    #     to_return(:status => 200, :body => bitly_response, :headers => {})
    #  post :post, tweet: {comment: "Стрим на http://omck.tv || text"}
    #  json = JSON.parse(response.body)
    #  expect(json["error"]).to be nil
    #  expect(json["tweet"]["comment"]).to eq("text")
    #  expect(json["tweet"]["user"]["id"]).to eq(@streamer.id)
    #end
  end

  describe "DELETE #delete" do
    it "should delete tweet from db" do
      delete :delete, id: @tweet.id
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["message"]).to eq("Deleted!")
    end
  end

end
