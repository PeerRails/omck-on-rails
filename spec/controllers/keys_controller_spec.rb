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
    it 'should not create new key' do
      user = create(:user)
      post :create, key: { user_id: user.id }
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json['message']).to eq('You dont have access to this action')
    end
    it 'should not update streamer attribute' do
      word = Faker::Lorem.word
      post :update, key: { user_id: @streamer.id, streamer: word }
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json['message']).to eq('You dont have access to this action')
    end
    it 'should not expire key' do
      user = create(:user, :mod)
      create(:key, user_id: user.id)
      post :expire, key: { user_id: user.id }
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json['message']).to eq('You dont have access to this action')
    end
    it 'should not expire key and create new for user'do
      user = create(:user, :mod)
      key = create(:key, user_id: user.id, expires: DateTime.now + 3600)
      post :regenerate, key: { user_id: user.id, expires: DateTime.now + 3600, streamer: 'Dwarf', game: 'Gaem' }
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json['message']).to eq('You dont have access to this action')
    end
  end

  describe 'GET #list' do
    it 'returns list of keys' do
      get :list
      json = JSON.parse(response.body)
      expect(json["error"]).to be nil
    end
  end
  describe 'GET #guests' do
    it 'returns list of guests' do
      create(:key, guest: true, created_by: @streamer.id)
      get :guests
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
    end
  end
  describe 'POST #create' do
    it 'should create new key' do
      Key.update(@key.id, expires: DateTime.now)
      expect { post :create, key: { user_id: @streamer.id } }.to change { Key.count }.by(1)
    end
    it 'should create new key and return it' do
      Key.update(@key.id, expires: DateTime.now)
      post :create, key: { user_id: @streamer.id }
      json = JSON.parse(response.body)
      expect(json['error']).to be_nil
    end
    it 'should not create new key and return duplicate error' do
      post :create, key: { user_id: @streamer.id }
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']).to eq('You already have key')
    end
    it 'should not create new key and return invalid data error' do
      post :create, key: { user_id: nil }
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']).to eq('Invalid data')
    end
    it 'should not create new key and return model error' do
      post :create, key: { user_id: 0 }
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']).to eq('Invalid data')
    end
    it 'should create new guest key' do
      expect { post :create_guest, key: { streamer: "Dwarf", game: "Flashback", movie: "Flash" } }.to change { Key.count }.by(1)
    end
  end
  describe 'PUT #update' do
    it 'should update streamer attribute' do
      word = Faker::Lorem.word
      put :update, key: { user_id: @streamer.id, streamer: word }
      key = Key.find_by_user_id(@streamer.id)
      expect(key.streamer).to eq(word)
    end
    it 'should update game attribute' do
      word = Faker::Lorem.word
      put :update, key: { user_id: @streamer.id, game: word }
      key = Key.find_by_user_id(@streamer.id)
      expect(key.game).to eq(word)
    end
    it 'should update movie attribute' do
      word = Faker::Lorem.word
      put :update, key: { user_id: @streamer.id, movie: word }
      key = Key.find_by_user_id(@streamer.id)
      expect(key.movie).to eq(word)
    end
    it 'should update movie, game and streamer attribute' do
      game = Faker::Lorem.word
      movie = Faker::Lorem.word
      streamer = Faker::Lorem.word
      put :update, key: { user_id: @streamer.id, movie: movie, game: game, streamer: streamer }
      key = Key.find_by_user_id(@streamer.id)
      expect(key.movie).to eq(movie)
      expect(key.game).to eq(game)
      expect(key.streamer).to eq(streamer)
    end
    it 'should not update key without params and return error' do
      word = Faker::Lorem.word
      put :update
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']).to eq('Not valid key')
    end
    it 'should not update key with incorrect id and return error' do
      word = Faker::Lorem.word
      put :update, key: { user_id: 1200 }
      json = JSON.parse(response.body)
      expect(json['error']).to be true
    end
    it 'should update movie, game and streamer and return updated key' do
      game = Faker::Lorem.word
      movie = Faker::Lorem.word
      streamer = Faker::Lorem.word
      put :update, key: { user_id: @streamer.id, movie: movie, game: game, streamer: streamer }
      json = JSON.parse(response.body)
      expect(json['movie']).to eq(movie)
      expect(json['game']).to eq(game)
      expect(json['streamer']).to eq(streamer)
    end
  end
  describe 'POST #expire' do
    it 'should expire key and return success' do
      post :expire, key: { user_id: @streamer.id }
      json = JSON.parse(response.body)
      expect(Key.find_by_user_id(@streamer.id).expires).to be < DateTime.now
      expect(json['error']).to be nil
      expect(json['expires']).to be < DateTime.now
    end
    it 'should not expire key without params and return error' do
      post :expire
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']).to eq('Invalid data')
    end
    it 'should not expire key with incorrect id and return error' do
      post :expire, key: { user_id: 1200 }
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']).to eq('Key doesnt exists or already expired')
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
      user = create(:user, :mod)
      key = user.keys.present.last
      expect { post :regenerate, key: { user_id: user.id } }.to change { Key.count }.by(1)
      expect(Key.find(key.id).expires).to be < DateTime.now
      json = JSON.parse(response.body)
      expect(json['secret']).not_to eq(key.key)
    end
    it 'should not expire key if incorrect id' do
      user = create(:user, :mod)
      key = create(:key, user_id: user.id, expires: DateTime.now + 3600)
      post :regenerate, key: { user_id: 120}
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']).to eq('Invalid key or already expired')
    end
    it 'should not expire key if no id' do
      user = create(:user, :mod)
      key = create(:key, user_id: user.id, expires: DateTime.now + 3600)
      post :regenerate, key: { user_id: nil }
      json = JSON.parse(response.body)
      expect(json['error']).to be true
      expect(json['message']).to eq('Invalid data')
    end
  end
  describe "POST #expire_guest" do
    it 'should expire guest key'do
      key = create(:key, created_by: @streamer.id, guest: true)
      post :expire_guest, id: key.id
      json = JSON.parse(response.body)
      expect(Key.find(key.id).expires).to be < DateTime.now
      expect(json['guest_id']).to eq(key.id)
    end
  end
  describe "POST #create_guest" do
    it 'should not create too many guest key'do
      post :create_guest, key: { streamer: "Dwarf", game: "Flashback", movie: "Flash" }
      post :create_guest, key: { streamer: "Dwarf", game: "Flashback", movie: "Flash" }
      post :create_guest, key: { streamer: "Dwarf", game: "Flashback", movie: "Flash" }
      post :create_guest, key: { streamer: "Dwarf", game: "Flashback", movie: "Flash" }
      post :create_guest, key: { streamer: "Dwarf", game: "Flashback", movie: "Flash" }
      post :create_guest, key: { streamer: "Dwarf", game: "Flashback", movie: "Flash" }
      post :create_guest, key: { streamer: "Dwarf", game: "Flashback", movie: "Flash" }
      json = JSON.parse(response.body)
      expect(json['error']).to be true
    end
  end
end
