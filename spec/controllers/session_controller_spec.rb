require 'rails_helper'

RSpec.describe SessionController, type: :controller do

    describe "unauthorized client" do
      let(:session_one){"sessions"}
      before do
        get :login, session: {session_id: session_one}
      end

      it { expect(response.status).to eq(200)}
      it "should create session" do
	      client = create(:client, nickname: session_one, password: session_one)
        post :create, params: {client: {nickname: client.nickname, password: session_one}}, session: {session_id: session_one}
        expect(response.status).to eq(302)
	      expect(Session.find_by_session_id(session_one).session_id).to eq(session_one)
	      expect(Session.find_by_session_id(session_one).client_id).to eq(client.id)
      end

      it {expect(post :create, params: {client: {nickname: "full", password: "123"}}).to redirect_to(login_path)}
      it {expect(post :create, params: {client: {nickname: session_one, password: "123"}}).to redirect_to(login_path)}
    end

  describe "authorized client" do
	  let(:session_one){"sessions"}
	  before do
	    client = create(:client)
	    session = create(:session, client: client, session_id: session_one)
	  end

	  it {expect( get :login, session: {session_id: session_one} ).to redirect_to(home_path) }

	  it "should destroy session" do
	    delete :destroy, session: {session_id: session_one}
	    expect(Session.find_by_session_id(session_one).expires).to be < DateTime.now
	    expect(response.status).to eq(302)

	  end
  end
end
