require 'rails_helper'

RSpec.describe User, type: :model do
    before do
        @user = create(:user)
    end
  it "has many keys" do
    expect(@user.keys.empty?).to be false
  end
  it "has many tweets" do
    create(:tweet, user_id: @user.id)
    expect(@user.tweets.empty?).to be false
  end
  it "has many sessions" do
    create(:session, user_id: @user.id)
    expect(@user.sessions.empty?).to be false
  end
  it "has many videos" do
    create(:video, user_id: @user.id)
    expect(@user.videos.empty?).to be false
  end
  it "has many api tokens" do
    expect(@user.api_token.empty?).to be false
  end
  it "has many streams" do
    create(:stream, user_id: @user.id, channel_id: 1, key_id: 1)
    expect(@user.streams.empty?).to be false
  end

  it "create stream key and api token after creation" do
    new_user = create(:user)
    expect(new_user.keys.empty?).to be false
    expect(new_user.api_token.empty?).to be false
  end

  it "has token" do
    expect(@user.token.nil?).to be false
  end

  it "logins with email"
  it "logins with twitter"
  it "logins with twitch"

end
