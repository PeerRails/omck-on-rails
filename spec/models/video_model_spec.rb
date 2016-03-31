require 'rails_helper'

RSpec.describe Video, type: :model do
  before do
    @user = create(:user, :streamer)
    @key = @user.keys.present.last
  end

  it "should belong to key" do
    video = create(:video, user_id: @user.id, key_id: @key.id)
    expect(@key.videos.last).to eq(video)
  end
  it "should belong to user" do
    video = create(:video, user_id: @user.id, key_id: @key.id)
    expect(@user.videos.last).to eq(video)
  end
  it "should validate token presence" do
    expect{create(:video, token: nil)}.to raise_error(ActiveRecord::RecordInvalid)
  end
  it "should validate token uniqueness" do
    video = create(:video, token: "123456")
    expect{create(:video, token: video.token)}.to raise_error(ActiveRecord::RecordInvalid)
  end
  it "should show deleted videos" do
    create(:video, deleted: true)
    expect(Video.deleted.count).to eq(1)
  end
  it "should list undeleted videos" do
    video = create(:video, token: Faker::Internet.password)
    expect(Video.list.last.token).to eq(video.token)
    expect(Video.list.length).to eq(1)
  end
end
