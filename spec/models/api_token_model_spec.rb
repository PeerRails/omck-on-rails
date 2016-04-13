require 'rails_helper'

RSpec.describe ApiToken, type: :model do
  before do
    @streamer = create(:user, :streamer)
    @gmod = create(:user, :mod)
    @expired = create(:api_token, user_id: @streamer.id, secret: "expired", expires_at: DateTime.now - 20)
    @first_token = create(:api_token, user_id: @streamer.id, secret: Faker::Internet.password)
    @second_token = create(:api_token, user_id: @gmod.id, secret: Faker::Internet.password)
  end

  it 'should exist and belong to user' do
    user = create(:user)
    create(:api_token, user_id: user.id)
    expect(user.token.secret).to eq(ApiToken.last.secret)
  end

  it 'should validate key secret uniqueness' do
    expect { create(:api_token, user_id: @streamer.id, secret: @first_token.secret) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should validate streamer presence' do
    expect { create(:api_token, user_id: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  #it 'should return present for user' do
    #expect(ApiToken.all.present.count).to eq(1)
  #end

  it 'should return expired keys' do
    @first_token.update(expires_at: DateTime.now)
    expect(ApiToken.expired.count).to eq(1)
  end

  it "should fill secret and expiration date before creation" do
    token = create(:api_token, user_id: @streamer.id)
    expect(token.secret).not_to be nil
    expect(token.expires_at).not_to be nil
  end
end
