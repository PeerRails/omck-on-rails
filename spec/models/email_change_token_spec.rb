# == Schema Information
#
# Table name: email_change_tokens
#
#  id         :integer          not null, primary key
#  client_id  :integer
#  secret     :string
#  confirmed  :boolean          default(FALSE)
#  old_email  :string
#  new_email  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe EmailChangeToken, type: :model do
    describe "validations" do
        it { should validate_presence_of(:client_id) }
        it { should belong_to(:client) }
        it { should validate_uniqueness_of(:secret) }
    end
end
