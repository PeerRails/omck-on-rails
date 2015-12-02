require 'rails_helper'

RSpec.describe KeysController, type: :controller do

  describe "GET #list" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
