require 'rails_helper'

RSpec.describe ClientsController, type: :controller do

    describe "right registration" do
        let(:session_one){"unsalted"}
        let(:subject){ post :create, params: { client: {nickname: "guest", password: "password"} }, session: {session_id: session_one}}
        before do
           #
        end
        it { expect(subject).to redirect_to(home_path)}
        it { expect{subject}.to change{Client.count}.by(1) }
        it { expect{subject}.to change{Session.count}.by(1) }

    end
    describe "irregular registration" do
        let(:session_one){"unsaltered"}
        let(:nopass){ post :create, params: {client: { nickname: "first", password: ""} } } 
        let(:nonick){ post :create, params: {client: { nickname: "", password: "salted"} } } 
        it "should not register duplicate nickname" do
           create(:client, nickname: "first")
           post :create, params: {client: { nickname: "first", password: "password"} }, session: {session_id: session_one}
           expect(response.status).to eq(302)
           expect(Client.count).to eq(1)
        end

        it { expect(nopass).to redirect_to(login_path) }
        it { expect{nopass}.to change{Client.count}.by(0)}

        it { expect(nonick).to redirect_to(login_path) }
        it { expect{nonick}.to change{Client.count}.by(0)}

    end
end
