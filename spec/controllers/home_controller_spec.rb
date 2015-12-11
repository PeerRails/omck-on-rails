require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    it "should request current_user" do
      get :index
      json = JSON.parse(response.body)
      expect(json["user"]).to be nil
    end
  end
end
