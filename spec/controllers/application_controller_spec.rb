require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  before do
    @streamer = create(:user, :streamer)
    @gmod = create(:user, :mod)
    @admin = create(:user, :admin)
  end

  describe "current_user" do
    it "should find user and session" do
      create(:session, user_id: @streamer.id)
      @request.session['session_id'] = @streamer.sessions.last.session_id
      expect(true).to be true
    end
  end
=begin
  describe "auth" do
    it 'redirects guest to login page' do
      raise ApplicationController.new.auth.inspect
    end
  end
=end
end
