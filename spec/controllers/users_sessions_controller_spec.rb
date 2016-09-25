require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  describe "GET #new" do
    it "should show login page" do
      get :new
      expect(response.status).to eq(200)
    end
    it "should redirect to home" do
      admin = create(:user, :admin)
      sign_in admin, scope: :user
      get :new
      expect(response).to redirect_to home_path
    end
  end
  describe "DELETE #destroy" do
    it "should redirect to home" do
      get :destroy
      expect(response).to redirect_to home_path
    end
    it "should destroy authed session and redirect to root" do
      admin = create(:user, :admin)
      sign_in admin, scope: :user
      get :destroy
      expect(response).to redirect_to home_path
      expect(subject.current_user).to be nil
    end
  end
end
