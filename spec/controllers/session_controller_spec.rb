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
            @client = create(:client, :streamer, email: "client@omck.tv", name: "Client", password: "secret", verified: DateTime.now)
        end

        it "should remember client in session" do
            post :enter, params: { email: "client@omck.tv", password: "secret" }, session: {session_id: "1231l2hk"}
            expect(@client.sessions.last.session_id).to eq("1231l2hk")
            expect(response.status).to eq(302)
        end

        it "should register new client" do
            post :register, params: { email: "newclient@omck.tv", name: "Dwarf" }, session: {session_id: Faker::Number.number(20)}
            client = Client.find_by_email("newclient@omck.tv")
            expect(client).not_to be nil
            expect(client.password).not_to be nil
        end

        it "should not register with errors" do
            expect{
                post :register, params: { email: "client@omck.tv", name: "Dwarf" }, session: {session_id: Faker::Number.number(20)}
            }.to change{Client.count}.by(0)

        end

        it "should verify client by email" do
            post :register, params: { email: Faker::Internet.email, name: "Dwarf" }, session: {session_id: Faker::Number.number(20)}
            token = EmailConfirmationToken.find_by_client_id(Client.last.id)
            expect(token.client.verified?).to be false
            expect(token.confirmed).to be false
            get :verify_email, params: {token: token.secret}
            new_token = EmailConfirmationToken.find(token.id)
            expect(new_token.confirmed).to be true
            expect(new_token.client.verified?).to be true
        end

        it "should show page Forgot Password" do
            get :forgot_password
            expect(response.status).to eq(200)
        end

        it "should restore password for client" do
            client = create(:client, :streamer)
            post :restore_password, params: { email: client.email }
            new_client = Client.find(client.id)
            expect(new_client.password).not_to eq(client.password)
        end

        it "should change password for client" do
            client = create(:client, :streamer)
            post :change_password, params: { email: client.email }
            expect(response.status).to eq(302)
        end

        it "should change email" do
            client = create(:client, :streamer)
            email = Faker::Internet.email
            post :change_email, params: { email: client.email, new_email: email }
            token = EmailChangeToken.where(new_email: email).first
            post :verify_email_change, params: {token: token.secret}
            new_token = EmailChangeToken.find(token.id)
            new_client = Client.find(client.id)
            expect(new_client.email).to eq(email)
            expect(new_token.confirmed).to be true
            expect(response.status).to eq(200)
        end

        end

    describe "login through external services" do
        it "should remember client who logged in through exserv" do

        end
        it "should register and remember client who logged in through exserv"
        it "should attach account from external service to client"
        it "should do some insane batshit"
    end

end
