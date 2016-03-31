require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @streamer = create(:user, :streamer)
    @gmod = create(:user, :mod)
    @admin = create(:user, :admin)
    @guest = create(:user, :guest)
  end

  it "should have many keys" do
    create(:key, user_id: @streamer.id, key: Faker::Internet.password, guest: true)
    expect(@streamer.keys.count).to be 2
  end
  it "should have many tweets" do
    create_list(:tweet, 15 ,user_id: @streamer.id)
    expect(@streamer.tweets.count).to eq(15)
  end
  it "should have many sessions" do
    5.times.each do
      create(:session, user_id: @streamer.id, session_id: Faker::Number.number(10))
    end
    expect(@streamer.sessions.count).to eq(5)
  end
  it "should have  many videos" do
    user = create(:user, twitter_id: "123456")
    video = create(:video, key_id: user.keys.present.last.id, user_id: user.id)
    expect(user.videos.count).to eq(1)
  end
  it "should validate twitter_id presence" do
    user = build(:user, twitter_id: "")
    expect(user.errors.full_messages).not_to eq(nil)
  end
  it "should show stuff members" do
    staff = [@streamer, @gmod, @admin]
    expect(User.staff.to_a).to eq(staff)
  end

  it "should login and create user" do
    omni = OmniAuth.config.mock_auth[:twitter]
    expect {
      user = User.login_with_twitter(omni)
    }.to change{ User.count }.by(1)
  end

  it "should login and authorise user" do
    omni = {
      uid: "11112",
      info: {
        name: "TestStreamer",
        nickname: "test_streamer",
        image: Faker::Avatar.image(Faker::Internet.user_name, "50x50", "jpg")
      },
      credentials: {
        token: Faker::Lorem.characters(16),
        secret: Faker::Lorem.characters(16)
      }
    }
    user = User.login_with_twitter(omni)
    expect(user.twitter_id).to eq(@streamer.twitter_id)
  end
  it "should return nil if incorrect data" do
    expect(User.login_with_twitter(nil)).to be_nil
  end
  it "should update user data" do
    omni = {
      uid: "11112",
      info: {
        name: Faker::Lorem.characters(8),
        nickname: Faker::Lorem.characters(10),
        image: Faker::Avatar.image(Faker::Internet.user_name, "50x50", "jpg")
      },
      credentials: {
        token: Faker::Lorem.characters(16),
        secret: Faker::Lorem.characters(16)
      }
    }
    user = User.login_with_twitter(omni)
    expect(user.name).to eq(omni[:info][:name])
  end
  it "should create user with key" do
    omni = {
      uid: "11112",
      info: {
        name: Faker::Lorem.characters(8),
        nickname: Faker::Lorem.characters(10),
        image: Faker::Avatar.image(Faker::Internet.user_name, "50x50", "jpg")
      },
      credentials: {
        token: Faker::Lorem.characters(16),
        secret: Faker::Lorem.characters(16)
      }
    }
    user = User.login_with_twitter(omni)
    expect(user.name).to eq(omni[:info][:name])
    expect(user.keys.last.nil?).to be false
  end
  it "should show api token" do
    token = create(:api_token, user_id: @streamer.id)
    expect(@streamer.token.id).to eq(token.id)
  end

end
