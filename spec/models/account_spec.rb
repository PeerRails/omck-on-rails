# == Schema Information
#
# Table name: accounts
#
#  id               :integer          not null, primary key
#  provider         :string
#  provider_user_id :integer
#  username         :string
#  fullname         :string
#  link             :string
#  client_id        :integer
#  profile_pic      :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe Account, type: :model do
  describe "associations" do
      it { should belong_to(:client)}
  end

  describe "authorization methods" do
    let(:twitter_id){"11112"}

    before do
        @streamer = create(:client, :streamer)
        @account = create(:account, provider_user_id: twitter_id, client_id: @streamer.id )
    end

    it "should login with twitter and create new client" do
      omni = OmniAuth.config.mock_auth[:twitter]
      expect {
          Account.login_with_twitter(omni)
      }.to change{ Client.count }.by(1)
    end

    it "should login and authorise user" do
        omni = {
          uid: "11112",
          info: {
            name: "TestStreamer",
            nickname: "test_streamer",
            image: Faker::Avatar.image(Faker::Internet.user_name, "50x50", "jpg")
          },
          credentials: {
            token: Faker::Lorem.characters(16),
            secret: Faker::Lorem.characters(16)
          }
        }
        account = Account.login_with_twitter(omni)
        client = account.client
        expect(client.id).to eq(@streamer.id)
        expect(account.id).to eq(@account.id)
    end
  end
end
