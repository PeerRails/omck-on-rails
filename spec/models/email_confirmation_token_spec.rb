# == Schema Information
#
# Table name: email_confirmation_tokens
#
#  id         :integer          not null, primary key
#  client_id  :integer
#  secret     :string
#  confirmed  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe EmailConfirmationToken, type: :model do
    describe "validations" do
        it { should validate_presence_of(:client_id) }
        it { should belong_to(:client) }
        it { should validate_uniqueness_of(:secret) }
    end
end
