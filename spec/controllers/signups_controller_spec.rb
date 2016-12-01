require 'rails_helper'

RSpec.describe SignupsController, type: :controller do
    describe "GET /signup" do
      before do
          get :new
      end
      it { expect{response.status}.to eq(200) }
    end

    describe "POST /signup right signup" do
        let(:session_one){"unsalted"}
        let(:subject){ post :create, params: { client: {nickname: "guest", password: "password"} }, session: {session_id: session_one}}

        it { expect(subject).to redirect_to(home_path)}
        it { expect{subject}.to change{Client.count}.by(1) }
        it { expect{subject}.to change{Session.count}.by(1) }


    end
end
