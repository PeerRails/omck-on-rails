require 'rails_helper'

RSpec.describe KeysController, type: :controller do
  before do
    @streamer = create(:user, :streamer)
    @key = create(:key, user_id: @streamer.id, key: Faker::Internet.password)
  end
  describe "GET #list" do
    it "returns http success" do
      get :list
      json = JSON.parse(response.body)
      expect(json.count).to be(1)
    end
  end
  describe "POST #create" do
    it "should create new key" do
      user = create(:user)
      expect {post :create, key: {user_id: user.id}}.to change{Key.count}.by(1)
    end
    it "should create new key and return it" do
      user = create(:user)
      post :create, key: {user_id: user.id}
      json = JSON.parse(response.body)
      #raise [user,json].inspect
      expect(json["error"]).to be_nil
      expect(json["user"]).to eq(user.name)
    end
    it "should not create new key and return duplicate error" do
      post :create, key: {user_id: @streamer.id}
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json["message"]).to eq("You already have key")
    end
    it "should not create new key and return invalid data error" do
      post :create, key: {user_id: nil}
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json["message"]).to eq("Invalid data")
    end
    it "should not create new key and return model error" do
      post :create, key: {user_id: 24}
      json = JSON.parse(response.body)
      expect(json["error"]).to be true
      expect(json["message"]).to eq("Invalid data")
    end
  end
  describe "POST #update" do
    it 'should update streamer attribute' do
      word = Faker::Lorem.word
      post :update, key: {user_id: @streamer.id, streamer: word}
      key = Key.find_by_user_id(@streamer.id)
      expect(key.streamer).to  eq(word)
    end
    it 'should update game attribute' do
      word = Faker::Lorem.word
      post :update, key: {user_id: @streamer.id, game: word}
      key = Key.find_by_user_id(@streamer.id)
      expect(key.game).to  eq(word)
    end
    it 'should update movie attribute' do
      word = Faker::Lorem.word
      post :update, key: {user_id: @streamer.id, movie: word}
      key = Key.find_by_user_id(@streamer.id)
      expect(key.movie).to  eq(word)
    end
    it 'should update movie, game and streamer attribute' do
      game = Faker::Lorem.word
      movie = Faker::Lorem.word
      streamer = Faker::Lorem.word
      post :update, key: {user_id: @streamer.id, movie: movie, game: game, streamer: streamer}
      key = Key.find_by_user_id(@streamer.id)
      expect(key.movie).to  eq(movie)
      expect(key.game).to  eq(game)
      expect(key.streamer).to  eq(streamer)
    end
    it 'should not update key with not params and return error' do
      word = Faker::Lorem.word
      post :update
      key = Key.find_by_user_id(@streamer.id)
      expect(key.movie).to  eq(@key.movie)
    end
    it 'should update movie, game and streamer and return updated key' do
      game = Faker::Lorem.word
      movie = Faker::Lorem.word
      streamer = Faker::Lorem.word
      post :update, key: {user_id: @streamer.id, movie: movie, game: game, streamer: streamer}
      json = JSON.parse(response.body)
      expect(json["movie"]).to  eq(movie)
      expect(json["game"]).to  eq(game)
      expect(json["streamer"]).to  eq(streamer)
    end
  end
end
