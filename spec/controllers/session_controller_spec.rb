require 'rails_helper'

RSpec.describe SessionController, type: :controller do

    describe "unauthorized client"
    let(:session_one){Faker::Internet.password(10)}
    before do
        get :login, session: {session_id: session_one}
    end

    it { expect(response.status).to eq(200)}
    it "should create session" do
        post :create, params: {client: {nickname: Faker::Internet.name, password: session_one}}, session: {session_id: session_one}
	expect(Session.find_by_session_id(session_one).session_id).to eq(session_one)

    end
end
