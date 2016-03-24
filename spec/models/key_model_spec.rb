require 'rails_helper'

RSpec.describe Key, type: :model do
  before do
    @streamer = create(:user, :streamer)
    @gmod = create(:user, :mod)
    @first_key = @streamer.keys.present.last
    @second_key = @gmod.keys.present.last
  end

  it "should belong to user" do
    user = create(:user)
    expect(user.keys.last.key).to eq(Key.last.key)
  end
  it "should have videos" do
    user = create(:user)
    key = user.keys.last
    video = create(:video, key_id: key.id, user_id: key.user_id)
    expect(key.videos.count).to eq(1)
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
  it "shoulda generate key before creation" do
    user = create(:user)
    user.keys.present.last.destroy
    key = Key.new(game: "game", movie: "movie", expires: DateTime.now + 23, streamer: "User", guest: false, user_id: user.id, created_by: user.id)
    key.save
    expect(key.key).not_to eq(nil)
  end
end
