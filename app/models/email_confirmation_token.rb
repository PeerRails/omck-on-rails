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
end
