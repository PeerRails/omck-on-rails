require 'rails_helper'

RSpec.describe Key, type: :model do
  before do
    @streamer = create(:user, :streamer)
    @gmod = create(:user, :mod)
    @first_key = create(:key, user_id: @streamer.id, key: Faker::Internet.password)
    @second_key = create(:key, user_id: @gmod.id, key: Faker::Internet.password)
  end

  it "should belong to user" do
    user = create(:user)
    key = create(:key, user_id: user.id)
    expect(user.keys.last.key).to eq(key.key)
  end
  it "should have videos" do
    user = create(:user)
    key = create(:key, user_id: user.id)
    video = create(:video, key_id: key.id, user_id: key.user_id)
    expect(key.videos.count).to eq(1)
  end
  it "should validate key secret presence" do
    expect{create(:key, user_id: @streamer.id, key: nil)}.to raise_error(ActiveRecord::RecordInvalid)
  end
  it "should validate key secret uniqueness" do
    expect{create(:key, user_id: @streamer.id, key: @first_key.key)}.to raise_error(ActiveRecord::RecordInvalid)
  end
  it "should validate expire date presence" do
    expect{create(:key, user_id: @streamer.id, expires: nil)}.to raise_error(ActiveRecord::RecordInvalid)
  end
  it "should validate streamer presence" do
    expect{create(:key, user_id: @streamer.id, streamer: nil)}.to raise_error(ActiveRecord::RecordInvalid)
  end
  it "should return present keys" do
    expect(Key.present.count).to eq(2)
  end
  it "should return expired keys" do
    create(:key, expires: DateTime.now)
    expect(Key.expired.count).to eq(1)
  end
  it "should return guest keys" do
    create(:key, guest: true)
    expect(Key.is_guest.count).to eq(1)
  end
  it "should return streamer keys" do
    create(:key, guest: true)
    expect(Key.streamers.count).to eq(2)
  end
end
