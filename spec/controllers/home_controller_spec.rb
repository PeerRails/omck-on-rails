require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
  describe "GET #login" do
    it "returns http success" do
      get :login
      expect(response).to have_http_status(:success)
    end
  end
  describe "GET #logout" do
    it "returns http success" do
      get :logout
      expect(response).to have_http_status(:success)
    end
  end
  describe "GET #admin" do
    it "returns http success" do
      get :admin
      expect(response).to have_http_status(:success)
    end
  end
  describe "GET #faq" do
    it "returns http success" do
      get :faq
      expect(response).to have_http_status(:success)
    end
  end

end
