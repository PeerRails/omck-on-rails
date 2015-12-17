require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #admin" do
    it "should restrict access to not logged in user" do
      get :admin
      expect(response.status).to eq(302)
    end
  end
end
