require 'rails_helper'

RSpec.describe SessionController, type: :controller do

    describe "general action" do
        it "should show login page" do
            get :login
            expect(response.status).to eq(200)
        end

        it "should logout from site and expire session" do
            client = create(:client, :streamer, email: "client@omck.tv", name: "Client", password: "secret")
            session = create(:session, client_id: client.id)
            get :logout, session: {session_id: session.session_id}
            expect(Session.find(session.id).expires).to be < DateTime.now
        end
    end

    describe "login through email" do
        before do
            @client = create(:client, :streamer, email: "client@omck.tv", name: "Client", password: "secret")
        end

        it "should remember client in session" do
            post :enter, params: { email: "client@omck.tv", password: "secret" }, session: {session_id: "1231l2hk"}
            expect(@client.sessions.last.session_id).to eq("1231l2hk")
            expect(response.status).to eq(302)
        end

        it "should register and remember new client" do
            post :register, params: { email: "newclient@omck.tv", name: "Dwarf" }, session: {session_id: Faker::Number.number(20)}
            client = Client.find_by_email("newclient@omck.tv")
            expect(client).not_to be nil
            expect(client.password).not_to be nil
        end

        it "should verify client by email" do

        end

        it "should change password for client"
        it "should change emails"

        end

    describe "login through external services" do
        it "should remember client who logged in through exserv"
        it "should register and remember client who logged in through exserv"
        it "should attach account from external service to client"
        it "should do some insane batshit"
    end

end
