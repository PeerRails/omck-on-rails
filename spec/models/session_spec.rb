# == Schema Information
#
# Table name: sessions
#
#  id         :integer          not null, primary key
#  ip         :inet
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  guest      :boolean          default(FALSE)
#  expires    :datetime
#  session_id :string
#  client_id  :integer
#

require 'rails_helper'

RSpec.describe Session, type: :model do
    describe "associations" do
        it { should belong_to(:client)}
        it { should validate_uniqueness_of(:session_id)}
    end

    describe "interfaces" do
        let(:client){create(:client, :viewer)}
        let(:session_id){Faker::Crypto.md5}

        it "should give an interface to create session" do
            expect(Session.create_session(client, session_id)).to be true
        end

        it "should give an interface destroy session" do
            session = create(:session, session_id: session_id, client_id: client.id)
            expect(Session.destroy_session(session_id)).to be true
        end
    end
end
