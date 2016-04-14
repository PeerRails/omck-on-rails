require 'rails_helper'

RSpec.describe Tweet, type: :model do
  before do
    @user = create(:user, :streamer)
    @tweet = create(:tweet, user_id: @user.id)
  end

  it "should belong to user" do
    expect(@user.tweets.last.user_id).to eq(@tweet.user_id)
  end

  it "should validate presence of comment" do
    expect{create(:tweet, user_id: @user.id, comment: nil)}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should validate length of comment" do
    text = SecureRandom.hex(142)
    expect{create(:tweet, user_id: @user.id, comment: text)}.to raise_error(ActiveRecord::RecordInvalid)
  end

end
