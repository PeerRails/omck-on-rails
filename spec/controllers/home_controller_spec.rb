require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #admin" do
    it "should redirect to login" do
      get :admin
      expect(response).to redirect_to "/login"
    end
  end
  describe "GET #admin authorized" do
    before do
      @admin = create(:user, :admin)
      sign_in @admin
    end
    it "should show home page" do
      get :admin
      expect(response.status).to eq(200)
    end
  end
end
