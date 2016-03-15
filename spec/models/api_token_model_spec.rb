require 'rails_helper'

RSpec.describe ApiToken, type: :model do
  before do
    @streamer = create(:user, :streamer)
    @gmod = create(:user, :mod)
    @first_token = create(:api_token, user_id: @streamer.id, secret: Faker::Internet.password)
    @second_token = create(:api_token, user_id: @gmod.id, secret: Faker::Internet.password)
  end

  it "should belong to user" do
    user = create(:user)
    token = create(:api_token, user_id: user.id)
    expect(user.api_token.secret).to eq(ApiToken.last.secret)
  end
  it "should validate token secret presence" do
    expect{create(:api_token, user_id: @streamer.id, secret: nil)}.to raise_error(ActiveRecord::RecordInvalid)
  end
  it "should validate key secret uniqueness" do
    expect{create(:api_token, user_id: @streamer.id, secret: @streamer.api_token.secret)}.to raise_error(ActiveRecord::RecordInvalid)
  end
  it "should validate expire date presence" do
    expect{create(:api_token, user_id: @streamer.id, expires_at: nil)}.to raise_error(ActiveRecord::RecordInvalid)
  end
  it "should validate streamer presence" do
    expect{create(:api_token, user_id: nil)}.to raise_error(ActiveRecord::RecordInvalid)
  end
  it "should return present keys" do
    expect(ApiToken.present.count).to eq(2)
  end
  it "should return expired keys" do
    create(:api_token, user_id: @streamer.id ,expires_at: DateTime.now)
    expect(ApiToken.expired.count).to eq(1)
  end
end
