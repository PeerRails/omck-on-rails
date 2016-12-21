require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  before do
    @client = create(:client)
    @session = create(:session, client: @client)
    @session_id = @session.session_id
    @account = create(:account, client: @client)
    @key = create(:key, client: @client)
  end

  describe "GET #get_me" do
    let(:json){JSON.parse(response.body)}
    it "returns http success" do
      get :get_me, session: { session_id: @session_id }
      expect(json['error']).to be nil
      expect(json['client']['name']).to eq(@client.name)
    end
  end

  describe "GET #get_secret" do
    let(:json){JSON.parse(response.body)}
    it "returns client secret" do
      get :get_secret, session: { session_id: @session_id }
      expect( json['error'] ).to be nil
      expect( json['key'] ).to eql(@key.key)
    end
  end

  describe "GET #update_key" do
    let(:json){JSON.parse(response.body)}
    it "return updated key" do
      get :update_key, session: { session_id: @session_id }, params: {key: { game: "NoGame" } }
      expect( json['error'] ).to be nil
      expect( json['key']['game'] ).to eql("NoGame")
    end
  end

  describe "GET #regenerate_key" do
    let(:json){JSON.parse(response.body)}
    it "should return new key" do
      get :regenerate_key, session: { session_id: @session_id }
      expect( json['error'] ).to be nil
      expect( json['key']['game'] ).to eql(@key.game)
    end
  end

end
