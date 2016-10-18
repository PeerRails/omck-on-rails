require 'rails_helper'

RSpec.describe FrontpageController, type: :controller do
  describe "GET #index" do
    it "should show main page" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe "GET #player" do
    it "should show player page" do
      get :player
      expect(response.status).to eq(200)
    end
  end

  describe "GET #fag" do
    before do
      get :faq
    end
    it {expect(response.status).to eq(200)}
  end
end
