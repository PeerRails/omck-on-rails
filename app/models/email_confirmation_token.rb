# == Schema Information
#
# Table name: email_confirmation_tokens
#
#  id         :integer          not null, primary key
#  client_id  :integer
#  secret     :string
#  confirmed  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EmailConfirmationToken < ApplicationRecord
    belongs_to :client
    validates_uniqueness_of :secret

    before_create :create_secret

    def update_client
        Client.update(self.client_id, verified: DateTime.now).save!
        self.update(confirmed: true)
    end

    def create_secret
        self.secret = ApplicationRecord.generate_unique_secure_token
    end
end
