require 'rails_helper'

RSpec.describe Api::V1::KeysController, type: :controller do
  before do
    @streamer = create(:user, :streamer)
    @key = @streamer.keys.present.last
    sign_in @streamer
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe "GET #retrive" do
    it "should show user key" do
      get :retrieve
      json = JSON.parse(response.body)["key"]
      expect(json["user_id"]).to eq(@streamer.id)
    end
  end
end