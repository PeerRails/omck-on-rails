require 'rails_helper'

RSpec.describe KeysController, type: :controller do
  before do
    @streamer = create(:user, :streamer)
    create(:key, user_id: @streamer.id, key: Faker::Internet.password)
    ApplicationController.new.current_user = true
  end
  describe "GET #list" do
    it "returns http success" do
      get :list
      json = JSON.parse(response.body)
      expect(json.count).to be(1)
    end
  end

end
