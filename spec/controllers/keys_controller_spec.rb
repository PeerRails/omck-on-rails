require 'rails_helper'

RSpec.describe KeysController, type: :controller do
  before do
    @streamer = create(:user, :streamer)
    @key = @streamer.keys.present.last
    sign_in @streamer
    request.env["HTTP_ACCEPT"] = 'application/json'
  end
  describe 'action without authorization' do
    before do
      sign_out @streamer
    end
    it "should not return list of keys" do
      get :list
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json['message']).to eq('You dont have access to this action')
    end
    it "should not return list of keys" do
      get :streamers
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json['message']).to eq('You dont have access to this action')
    end
    it 'should not create new key' do
      user = create(:user)
      post :create, key: { user_id: user.id }
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json['message']).to eq('You dont have access to this action')
    end
    it 'should not update streamer attribute' do
      word = Faker::Lorem.characters(10)
      post :update, key: { user_id: @streamer.id, streamer: word }
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json['message']).to eq('You dont have access to this action')
    end
    it 'should not expire key' do
      user = create(:user, :mod)
      post :expire, key: { user_id: user.id }
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json['message']).to eq('You dont have access to this action')
    end
    it 'should not expire key and create new for user'do
      user = create(:user, :mod)
      post :regenerate, key: { user_id: user.id, expires: DateTime.now + 3600, streamer: 'Dwarf', game: 'Gaem' }
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json['message']).to eq('You dont have access to this action')
    end
  end

  describe 'GET #list' do
    it 'returns user key' do
      get :list
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
    end
  end

  describe 'GET #streamers' do
    it 'returns list of keys' do
      get :streamers
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
    end
  end
  describe 'GET #guests' do
    it 'returns list of guests' do
      create(:key, guest: true, user_id: @streamer.id)
      get :guests
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
    end
  end
  describe 'POST #create' do
    it 'should create new key' do
      @key.expire
      expect { post :create, key: { user_id: @streamer.id } }.to change { Key.count }.by(1)
    end
    it 'should create new key and return it' do
      @key.expire
      post :create, key: { user_id: @streamer.id }
      json = JSON.parse(response.body)
      expect(json['error']).to be_nil
    end
    it 'should not create new key and return duplicate error' do
      post :create, key: { user_id: @streamer.id }
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']["key"][0]).to eq('Рабочий ключ уже существует.')
    end
    it 'should not create new key and return invalid data error' do
      post :create, key: { user_id: nil }
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']["user_id"][0]).to eq('не может быть пустым')
    end
    it 'should not create new key and return model error' do
      post :create, key: { user_id: 0 }
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']).to eq('Record not Found')
    end
    it 'should create new guest key' do
      expect { post :create_guest, key: { streamer: "Dwarf", game: "Flashback", movie: "Flash" } }.to change { Key.count }.by(1)
    end
  end
  describe 'PUT #update' do
    it 'should update streamer attribute' do
      word = Faker::Lorem.characters(10)
      put :update, key: { user_id: @streamer.id, streamer: word }
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["key"]["streamer"]).to eq(word)
    end
    it 'should update game attribute' do
      word = Faker::Lorem.characters(10)
      put :update, key: { user_id: @streamer.id, game: word }
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["key"]["game"]).to eq(word)
    end
    it 'should update movie attribute' do
      word = Faker::Lorem.characters(10)
      put :update, key: { user_id: @streamer.id, movie: word }
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["key"]["movie"]).to eq(word)
    end
    it 'should update movie, game and streamer attribute' do
      game = Faker::Lorem.characters(10)
      movie = Faker::Lorem.characters(10)
      streamer = Faker::Lorem.characters(10)
      put :update, key: { user_id: @streamer.id, movie: movie, game: game, streamer: streamer }
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json["key"]["movie"]).to eq(movie)
      expect(json["key"]["streamer"]).to eq(streamer)
      expect(json["key"]["game"]).to eq(game)
    end
    it 'should not update key without params and return error' do
      put :update
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']).to eq('No valid params')
    end
    it 'should not update key with incorrect id and return error' do
      put :update, key: { user_id: 1200 }
      json = JSON.parse(response.body)
      expect(json['error']).to be true
    end
    it 'should update movie, game and streamer and return updated key' do
      game = Faker::Lorem.characters(10)
      movie = Faker::Lorem.characters(10)
      streamer = Faker::Lorem.characters(10)
      put :update, key: { user_id: @streamer.id, movie: movie, game: game, streamer: streamer }
      json = JSON.parse(response.body)
      expect(json['error']).to be nil
      expect(json['key']['movie']).to eq(movie)
      expect(json['key']['game']).to eq(game)
      expect(json['key']['streamer']).to eq(streamer)
    end
  end
  describe 'POST #expire' do
    it 'should expire key and return success' do
      post :expire, key: { user_id: @streamer.id }
      json = JSON.parse(response.body)
      expect(Key.find_by_user_id(@streamer.id).expires).to be < DateTime.now
      expect(json['error']).to be nil
      expect(json['key']['expires']).to be < DateTime.now
    end
    it 'should not expire key without params and return error' do
      post :expire
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']).to eq('No valid params')
    end
    it 'should not expire key with incorrect id and return error' do
      post :expire, key: { user_id: 1200 }
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']).to eq('Record not Found')
    end
    it 'should not expire expired key and return error' do
      user = create(:user, :mod)
      Key.update(user.keys.present.last.id, expires: DateTime.now)
      post :expire, key: { user_id: user.id }
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']).to eq('Key doesnt exists or already expired')
    end
  end
  describe 'POST #regenerate' do
    it 'should expire key and create new for user' do
      expect { post :regenerate, key: { user_id: @streamer.id } }.to change { Key.count }.by(1)
      expect(Key.find(@key.id).expires).to be < DateTime.now
      json = JSON.parse(response.body)
      expect(json['error']).to be nil
      expect(json['key']['id']).to eq(@streamer.keys.present.last.id)
    end
    it 'should not expire key if incorrect id' do
      create(:user, :mod)
      post :regenerate, key: { user_id: 120}
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']).to eq('Record not Found')
    end
    it 'should not expire key if no id' do
      create(:user, :mod)
      post :regenerate, key: { user_id: nil }
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']).to eq('Record not Found')
    end
  end
  describe "POST #expire_guest" do
    it 'should expire guest key'do
      key = create(:key, user_id: @streamer.id, guest: true)
      post :expire_guest, id: key.id
      json = JSON.parse(response.body)
      expect(Key.find(key.id).expires).to be < DateTime.now
      expect(json['error']).to be nil
      #expect(json['key']['expires']).to eq(DateTime.now.strftime("%Y-%m-%d"))
    end
  end
  describe 'GET #secret' do
    it 'returns user key secret' do
      get :secret, id: @key.id
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json['key']["secret"]).to eq(@key.key)
    end

    it 'should not return another user key secret' do
      user = create(:user, :mod)
      get :secret, id: user.keys.present.last.id
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
    end

    it 'should return another user key secret if admin' do
      user = create(:user, :mod)
      sign_in user
      get :secret, id: user.keys.present.last.id
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
      expect(json['key']["secret"]).to eq(user.keys.present.last.key)
    end
  end
end
