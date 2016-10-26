# == Schema Information
#
# Table name: api_tokens
#
#  id         :integer          not null, primary key
#  secret     :string
#  user_id    :integer
#  expires_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :integer
#

require 'rails_helper'

RSpec.describe ApiToken, type: :model do
    describe "Api Token Model" do
        before do
            @client = create(:client, :admin)
            @api_token = create(:api_token, client_id: @client.id)
        end

        let(:token){build(:api_token, client_id: @client.id)}

        it { should belong_to(:client)}

        it { should validate_uniqueness_of(:secret)}

        it "should show unexpired tokens" do
            expect(ApiToken.present.empty?).to be false
        end

        it "should generate secret on creation" do
            expect(token.secret).not_to eq(@api_token.secret)
        end

        it "should be unexpired on creation" do
            expect(token.expires_at).to be > DateTime.now
        end

    end
end
