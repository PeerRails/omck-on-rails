require 'rails_helper'

RSpec.describe Session, type: :model do
  before do
    @streamer = create(:user, :streamer)
    @session = create(:session, user_id: @streamer.id, session_id: 'streamer_sessions', guest: false)
  end

  it 'should belong to user' do
    session = create(:session, user_id: @streamer.id)
    expect(@streamer.sessions.last).to eq(session)
  end
  it 'should validate presence of session_id' do
    expect do
      create(:session, user_id: @streamer.id, session_id: nil)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end
  it 'should validate uniqueness of session_id' do
    create(:session, user_id: @streamer.id, session_id: 'test')
    expect do
      create(:session, session_id: 'test')
    end.to raise_error(ActiveRecord::RecordInvalid)
  end
  it 'should return list of guest sessions' do
    create(:session, guest: true, user_id: nil)
    expect(Session.is_guest.count).to eq(1)
  end
  it 'should return list of user sessions' do
    expect(Session.is_user.count).to eq(1)
  end
  it 'should create session' do
    expect do
      Session.create_session(@streamer, 'test')
    end.to change{Session.count}.by(1)
  end
  it 'should reset session' do
    expect(Session.create_session(@streamer, @session.session_id)[:action]).to eq("reset_session")
  end
  it 'should destroy session' do
    Session.destroy_session(@session.session_id)
    expect(Session.find(@session.id).expires).to be < DateTime.now
  end
  it "should not destroy wrong session" do
    Session.destroy_session("123456")
    expect(Session.where("expires < ?", DateTime.now).count).to eq(0)
  end
end
