require 'rails_helper'

RSpec.describe ApiApplicationController, type: :controller do
  before do
    @user = create(:user)
    @token = create(:api_token, user_id: @user.id)
    request.headers["HTTP_API_TOKEN"] = @token.secret
  end
  it "should authorize through headers" do
    post :check
    #raise request.headers.inspect
    json = JSON.parse(response.body)
    expect(json["user"]["id"]).to eq(@user.id)
  end

  it "should not authorize through invalide headers" do
    request.headers["HTTP_API_TOKEN"] = nil
    post :check
    json = JSON.parse(response.body)
    expect(json["user"]["id"]).to eq(nil)
  end
end
