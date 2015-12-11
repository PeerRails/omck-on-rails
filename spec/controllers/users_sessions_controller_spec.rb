require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  describe "GET #new" do
    it "should redirect to omniauth provider" do
      get :new
      expect(response.status).to eq(302)
    end
    it "should redirect to root" do
      admin = create(:user, :admin)
      sign_in :user, admin
      get :new
      expect(response).to redirect_to root_path
    end
  end
  describe "DELETE #destroy" do
    it "should redirect to root" do
      get :destroy
      expect(response).to redirect_to root_path
    end
    it "should destroy authed session and redirect to root" do
      admin = create(:user, :admin)
      sign_in :user, admin
      get :destroy
      expect(response).to redirect_to root_path
      expect(subject.current_user).to be nil
    end
  end
end
