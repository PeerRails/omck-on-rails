require 'rails_helper'

RSpec.describe Api::V1::StreamsController, type: :controller do
  before do
    @streamer = create(:user, :streamer)
    @token = create(:api_token, user_id: @streamer.id)
    request.headers["HTTP_API_TOKEN"] = @token.secret
    @stream = create(:stream, user_id: @streamer.id, key_id: @streamer.keys.present.last.id, channel_id: 1)
    10.times {|i| create(:stream, user_id: i, key_id: @streamer.keys.present.last.id, channel_id: 1 )}
    request.env["HTTP_ACCEPT"] = 'application/json'
  end
  let(:clear_headers) {request.headers["HTTP_API_TOKEN"] = nil}
  let(:json) {JSON.parse(response.body)}

  describe "GET #last" do
    describe "gets last 10 streams" do
      before do
        get :last
      end

      it {expect(json["error"]).to be nil}
      it {expect(json["streams"].first["key_id"]).to eq(@streamer.keys.present.last.id)}
      it {expect(json["streams"].first["channel_id"]).to eq(1)}
      it {expect(json["streams"].count).to eq(10)}

    end

    describe "gets last streams of user" do
      before do
        get :last, user: @streamer.id
      end

      it {expect(json["error"]).to be nil}
      it {expect(json["streams"].first["user_id"]).to eq(@streamer.id)}
      it {expect(json["streams"].first["key_id"]).to eq(@streamer.keys.present.last.id)}
      it {expect(json["streams"].first["channel_id"]).to eq(1)}
      it {expect(json["streams"].count).not_to eq(10)}
    end

  end

  describe "GET #list" do
    describe "gets all streams of user" do
      before do
        get :by_user, user: @streamer.id
      end

      it {expect(json["error"]).to be nil}
      it {expect(json["streams"].first["user_id"]).to eq(@streamer.id)}
      it {expect(json["streams"].first["key_id"]).to eq(@streamer.keys.present.last.id)}
      it {expect(json["streams"].first["channel_id"]).to eq(1)}
    end

  end

  describe "GET #show" do
    describe 'gets required stream' do
      before do
        get :show, id: @stream.id
      end

      it { expect(json["error"]).to be nil }
      it { expect(json["stream"]["user_id"]).to eq(@streamer.id) }
      it { expect(json["stream"]["key_id"]).to eq(@streamer.keys.present.last.id) }
      it { expect(json["stream"]["channel_id"]).to eq(1) }
      it { expect(json["stream"]["ended_at"]).to be nil }
    end
  end

  describe "GET #stop" do
    describe 'stops required stream' do
      before do
        get :stop, id: @stream.id
      end

      it {expect(json["error"]).to be nil}
      it {expect(json["stream"]["user_id"]).to eq(@streamer.id)}
      it {expect(json["stream"]["key_id"]).to eq(@streamer.keys.present.last.id)}
      it {expect(json["stream"]["channel_id"]).to eq(1)}
      it {expect(json["stream"]["ended_at"]).not_to be nil}
    end

    describe 'returns error if required stream was already stopped' do
      before do
        @stream.update(ended_at: DateTime.parse("1970-01-01"))
        get :stop, id: @stream.id
      end

      it {expect(json["error"]).to be true}
      it {expect(json["message"]).to eq("It was already stopped")}
    end
  end

  describe "POST #new" do
    describe "creates new stream" do
      before do
        admin = create(:user, :admin)
        token = create(:api_token, user_id: admin.id)
        request.headers["HTTP_API_TOKEN"] = token.secret
        post :create, stream: {user_id: @streamer.id, key_id: @streamer.keys.present.last.id, channel_id: 1, ended_at: DateTime.parse("1970-01-01")}
      end

      it { expect(json["error"]).to be nil }
      it { expect(json["stream"]["user_id"]).to eq(@streamer.id) }
      it { expect(json["stream"]["key_id"]).to eq(@streamer.keys.present.last.id) }
      it { expect(json["stream"]["channel_id"]).to eq(1) }
      it { expect(json["stream"]["ended_at"]).not_to be nil }

    end

    describe "return error with invalid params" do
      before do
        admin = create(:user, :admin)
        token = create(:api_token, user_id: admin.id)
        request.headers["HTTP_API_TOKEN"] = token.secret
        post :create, stream: {user_id: nil}
      end

      it { expect(json["error"]).to be true }

    end
  end

  describe "DELETE #delete" do
    describe "deletes stream" do
      before do
        admin = create(:user, :admin)
        token = create(:api_token, user_id: admin.id)
        request.headers["HTTP_API_TOKEN"] = token.secret
        delete :delete, id: @stream.id
      end

      it { expect(json["error"]).to be nil }
      it { expect(json["message"]).to eq("Deleted!") }
      it { expect{Stream.find(@stream.id)}.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe "POST #period" do
    describe "shows streams of required period" do
      before do
        15.times {|i| create(:stream, user_id: i, key_id: @streamer.keys.present.last.id, channel_id: 1, ended_at: Faker::Date.between(2.days.ago, Date.today) )}
        post :by_period, date: {started: 2.days.ago.strftime("%Y-%m-%d"), ended: DateTime.now.strftime("%Y-%m-%d")}
      end

      it {expect(json["error"]).to be nil}
      it {expect(json["streams"].first["key_id"]).to eq(@streamer.keys.present.last.id)}
      it {expect(json["streams"].first["channel_id"]).to eq(1)}
      it {expect(json["streams"].count).to eq(15)}
    end
  end
end
