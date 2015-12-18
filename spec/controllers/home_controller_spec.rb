require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    it "should redirect to login" do
      get :index
      expect(response).to redirect_to "/login"
    end
  end
  describe "GET #index authorized" do
    before do
      @admin = create(:user, :admin)
      sign_in @admin
    end
    it "should show home page" do
      get :index
      expect(response.status).to eq(200)
    end
  end
end
