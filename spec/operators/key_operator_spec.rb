require 'rails_helper'

RSpec.describe KeyOperator do
  describe "#get_key" do
    let(:client){create(:client)}
    it "should success response" do
      key = create(:key, client: client)
      response = KeyOperator.get_key(key.client_id)
      expect(response.success?).to be true
      expect(response.data.class).to be Key
    end

    it "should show errors" do
      response = KeyOperator.get_key(999)
      expect(response.success?).to be false
      expect(response.message).to eql("Key not found")
    end
  end

  describe "#update" do
    let(:client){create(:client)}
    it "should update key" do
      id = create(:key, client: client).id
      options = {client_id: client.id, data: { game: "zombies" } }
      key = KeyOperator.update(options)
      expect(key.success?).to be true
      expect( Key.find(id).game ).to eql("zombies")
    end

    it "should show errors" do
      create(:key, client: client)
      key = KeyOperator.update({client_id: client.id, data: { game: "a"*360 } })
      expect( key.success? ).to be false
      expect( key.message ).to eql("Key data is invalid")
    end
  end

  describe "#create" do
    let(:client){create(:client)}
    it "should create new key" do
      options = {client_id: client.id}
      key = KeyOperator.create(options)
      expect(key.success?).to be true
      expect(key.data.client_id).to eq(client.id)
    end

    it "should show error" do
      # TODO: client verification
      #
      # key validation
      key = KeyOperator.create({client_id: client.id, game: "a"*360 })
      expect(key.success?).to be false
      expect(key.message).to eql("Key data is invalid")
      # key duplication
      create(:key, client: client)
      dupkey = KeyOperator.create({client_id: client.id})
      expect(dupkey.success?).to be false
      expect(dupkey.message).to eql("Key data is invalid")
    end
  end

  describe "#expire" do
    let(:client){create(:client)}
    it "should expire date of key" do
      create(:key, client: client)
      key = KeyOperator.expire(client.id)
      expect(key.success?).to be true
      expect(key.data.expires).to be < DateTime.now
    end

    it "should show error" do
      key = KeyOperator.expire(999)
      expect(key.success?).to be false
      expect(key.message).to eql("Key not found")
    end
  end

  describe "#regenerate" do
    it "should regenerate key" do
      client = create(:client)
      old_key = create(:key, client: client)

      key = KeyOperator.regenerate(client.id)
      expect(key.success?).to be true
      expect(key.data.key).not_to eq(Key.find(old_key.id).key)
      expect(key.data.movie).to eq(old_key.movie)
      expect(key.data.game).to eq(old_key.game)
      expect(key.data.streamer).to eq(old_key.streamer)
    end

    it "should show error" do
      key = KeyOperator.regenerate(999)
      expect(key.success?).to be false
      expect(key.message).to eq("Key not found")
    end
  end
end
