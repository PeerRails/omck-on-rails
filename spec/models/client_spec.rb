# == Schema Information
#
# Table name: clients
#
#  id          :integer          not null, primary key
#  name        :string           default("Dwarf")
#  email       :string
#  password    :string
#  admin       :boolean          default(FALSE)
#  streamer    :boolean          default(FALSE)
#  bot         :boolean          default(FALSE)
#  verified    :datetime
#  remember_at :datetime
#  last_login  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Client, type: :model do

  describe "associations" do
    it { should have_many(:tweets)}
    it { should have_many(:videos)}
    it { should have_many(:api_tokens)}
    it { should have_many(:streams)}
    it { should have_many(:accounts)}
    it { should have_one(:key)}
  end

  describe "validations" do
  	before do
  		@client = create(:client, :viewer)
  	end

  	it "should validate uniqueness of email" do
  		client = build(:client, email: @client.email)
  		expect{client.save}.to change{Client.count}.by(0)
  	end

  	it "should validate presence of name" do
  		client = build(:client, name: nil)
  		expect{client.save}.to change{Client.count}.by(0)
  	end

  	it "should show admin" do
  		expect(@client.admin?).to be false
  	end
  	it "should show streamer" do
  		expect(@client.streamer?).to be false
  	end
  	it "should show bot" do
  		expect(@client.bot?).to be false
  	end
  	it "should show viewer" do
  		expect(@client.viewer?).to be true
  	end
  	it "should show verified" do
  		expect(@client.verified?).to be true
  	end

  	it "should show last login" do
  		expect(@client.last_login).to be < DateTime.now
  	end

  	it "should show current sessions" do
  		# Refactor this user_id
  		create(:session, client_id: @client.id, user_id: @client.id)
  		sessions = @client.sessions
  		expect(sessions.count).to eq(1)
  		expect(sessions.last.client_id).to eq(@client.id)
  		expect(sessions.last.expires).to be > DateTime.now
  	end

    it "should add to client a new stream key" do
      expect{create(:client)}.to change{Key.count}.by(1)
    end

    it "should add to client a new api token" do
      expect{create(:client)}.to change{ApiToken.count}.by(1)
    end

  end
end
