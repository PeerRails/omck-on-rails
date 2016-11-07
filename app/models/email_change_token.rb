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

class EmailChangeToken < ApplicationRecord
    belongs_to :client
    validates_presence_of :client_id
    validates_uniqueness_of :secret

    before_create :create_secret

    def update_email
        Client.update(self.client_id, email: self.new_email).save!
        self.update(confirmed: true)
    end

    def create_secret
        self.secret = ApplicationRecord.generate_unique_secure_token
    end
end
